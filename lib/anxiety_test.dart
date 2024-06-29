import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class AnxietyTestScreen extends StatefulWidget {
  const AnxietyTestScreen({super.key});

  @override
  _AnxietyTestScreenState createState() => _AnxietyTestScreenState();
}

class _AnxietyTestScreenState extends State<AnxietyTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Over the last 2 weeks, how often have you felt nervous, anxious, or on edge?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, how often have you been unable to stop or control worrying?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you felt restless or on edge, unable to relax?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'A little', 'points': 1},
        {'option': 'Quite a bit', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you been easily tired or fatigued?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you been having difficulty concentrating on things, such as reading the newspaper or watching television?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you been so worried that you have trouble falling or staying asleep?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you been irritable or on edge with people?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you been afraid that something awful is going to happen?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'All the time', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you avoided places or situations that might cause you to worry?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'All the time', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, have you had difficulty controlling your worries that have made it hard to get things done at work, school or home?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'To some degree', 'points': 1},
        {'option': 'To a considerable degree', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
  ];

  Map<int, int> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anxiety Test'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${index + 1}: ${questions[index]['question']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: List.generate(
                      questions[index]['options'].length,
                      (optionIndex) {
                        return RadioListTile<int>(
                          title: Text(questions[index]['options'][optionIndex]['option']),
                          value: questions[index]['options'][optionIndex]['points'],
                          groupValue: selectedOptions[index],
                          onChanged: (value) {
                            setState(() {
                              selectedOptions[index] = value!;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          int totalScore = 0;
          selectedOptions.forEach((key, value) {
            totalScore += value;
          });

          double averageScore = totalScore / questions.length;
          String diagnosis = averageScore >= 2 ? 'Yes' : 'No';

          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
                'anxietyTestScore': totalScore,
                'anxietyTestAverage': averageScore,
                'anxietyDiagnosis': diagnosis,
                'timestamp': Timestamp.now(),
              });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Test Result'),
                    content: Text('Total Score: $totalScore\nAverage Score: ${averageScore.toStringAsFixed(2)}\nDiagnosis: $diagnosis'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(testName: 'Anxiety Test'),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text('User not logged in.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            }
          } catch (e) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text('Failed to save the result: $e'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
