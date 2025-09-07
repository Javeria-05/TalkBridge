import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lessons_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<List<String>> fetchLanguages() async {
    // ✅ Collection name capital "Languages" (Firestore is case-sensitive)
    final snapshot =
        await FirebaseFirestore.instance.collection('Languages').get();

    final languages = snapshot.docs.map((doc) => doc.id).toList();
    debugPrint("Languages fetched: $languages");
    return languages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TalkBridge")),
      body: FutureBuilder<List<String>>(
        future: fetchLanguages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Languages Found"));
          }

          final languages = snapshot.data!;
          return ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          LessonsPage(language: languages[index]),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      languages[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
