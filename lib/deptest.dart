import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class DepressionTestScreen extends StatefulWidget {
  const DepressionTestScreen({super.key});

  @override
  _DepressionTestScreenState createState() => _DepressionTestScreenState();
}

class _DepressionTestScreenState extends State<DepressionTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Over the past 2 weeks, have you felt persistently sad, hopeless, or irritable for most of the day?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Did you experience a significant loss of interest or pleasure in most activities you used to enjoy?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Have you had significant changes in appetite or weight (either weight loss or gain) without trying?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Have you experienced trouble sleeping (insomnia) or sleeping too much (hypersomnia) nearly every day?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do you feel restless or fidgety, or are you slowed down and have difficulty moving or speaking?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you feel constantly tired or lacking in energy?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'During this period, have you experienced feelings of worthlessness or excessive guilt, even over trivial matters?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do you have difficulty concentrating on tasks or making decisions nearly every day?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Over the past 2 weeks, have you felt a general sense of hopelessness or helplessness about the future, even for small things?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Have you felt that your depression has significantly interfered with your work, social life, or other important areas of functioning?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
  ];

  Map<int, int> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depression Test'),
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
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: List.generate(
                      questions[index]['options'].length,
                      (optionIndex) {
                        return RadioListTile<int>(
                          title: Text(questions[index]['options'][optionIndex]
                              ['option']),
                          value: questions[index]['options'][optionIndex]
                              ['points'],
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
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .update({
                'DepressionTestType':
                    'Depression Test', // Set the recent test type
                'DepressionTestScore': totalScore,
                'DepressionTestAverage': averageScore,
                'depressionDiagnosis': diagnosis,
                'timestamp': Timestamp.now(),
              });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Test Result'),
                    content: Text(
                        'Total Score: $totalScore\nAverage Score: ${averageScore.toStringAsFixed(2)}\nDiagnosis: $diagnosis'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(testName: 'Depression Test'),
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
