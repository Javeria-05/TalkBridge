import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  final String language;
  const QuizPage({Key? key, required this.language}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ black background
      appBar: AppBar(
        title: Text("${widget.language} Quiz"),
        backgroundColor: Colors.grey[900], // ✅ dark appbar
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Languages')
            .doc(widget.language)
            .collection('Quiz')
            .doc('Set 1') // ✅ ek hi doc me saare questions
            .get(),
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
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "No quiz found!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List questions = data['Questions'] ?? [];

          if (questions.isEmpty) {
            return const Center(
              child: Text(
                "No questions available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (currentQuestion >= questions.length) {
            // ✅ Quiz Finished
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Quiz Finished!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Your Score: $score / ${questions.length}",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        currentQuestion = 0;
                        score = 0;
                      });
                    },
                    child: const Text("Restart Quiz"),
                  ),
                ],
              ),
            );
          }

          final questionData = questions[currentQuestion];
          final String question = questionData['question'] ?? "No Question";
          final List options = questionData['options'] ?? [];
          final String correctAnswer = questionData['answer'] ?? "";

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Question ${currentQuestion + 1}/${questions.length}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ✅ white text
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  question,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white, // ✅ white text for Chinese also
                  ),
                ),
                const SizedBox(height: 30),
                ...options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800], // dark button
                        foregroundColor: Colors.white, // ✅ white text
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (option == correctAnswer) {
                          score++;
                        }
                        setState(() {
                          currentQuestion++;
                        });
                      },
                      child: Text(
                        option,
                        style: const TextStyle(color: Colors.white), // ✅ fixed
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
