import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_page.dart'; // Make sure QuizPage exists

class LessonsPage extends StatelessWidget {
  final String language; // pass language name
  const LessonsPage({Key? key, required this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Firestore Stream Setup
    final Stream<QuerySnapshot> lessonsStream = FirebaseFirestore.instance
        .collection('Languages')
        .doc(language)
        .collection('Lessons')
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.black, // ✅ black background
      appBar: AppBar(
        title: Text("$language Lessons"),
        backgroundColor: Colors.grey[900], // ✅ dark appbar
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: lessonsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Lessons Found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final lessons = snapshot.data!.docs;

          return ListView.builder(
            itemCount: lessons.length + 1, // +1 for quiz button
            itemBuilder: (context, index) {
              if (index == lessons.length) {
                // Last item = only one Quiz button
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.grey[800], // dark button
                      foregroundColor: Colors.white, // text color
                    ),
                    child: const Text("Start Quiz"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizPage(language: language),
                        ),
                      );
                    },
                  ),
                );
              }

              // Normal lesson item
              final doc = lessons[index];
              final data = doc.data() as Map<String, dynamic>;

              final lessonTitle = (data['title'] ?? doc.id).toString();
              final lessonContent = (data['content'] ?? 'No content').toString();

              return Card(
                color: Colors.grey[900], // ✅ dark card
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    lessonTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // ✅ white text
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonDetailPage(
                          title: lessonTitle,
                          content: lessonContent,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LessonDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const LessonDetailPage({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ black background
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.grey[900], // ✅ dark appbar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.white, // ✅ white text
            ),
          ),
        ),
      ),
    );
  }
}
