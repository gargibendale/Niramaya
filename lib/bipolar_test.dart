import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class BipolarTestScreen extends StatefulWidget {
  const BipolarTestScreen({super.key});

  @override
  _BipolarTestScreenState createState() => _BipolarTestScreenState();
}

class _BipolarTestScreenState extends State<BipolarTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Over the past 2 weeks, have you experienced a period where you felt unusually energetic or excited, with increased talkativeness or racing thoughts?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'During this period, did you need significantly less sleep than usual and feel like you didn\'t need any rest?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Did you feel overly confident or have inflated self-esteem during this time?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Did you become easily distracted or find it hard to focus on tasks because of your racing thoughts?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the past 2 weeks, have you felt persistently sad, hopeless, or irritable for most of the day?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Did you experience a significant loss of interest or pleasure in most activities you used to enjoy?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Have you had significant changes in appetite or weight (either weight loss or gain) without trying?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'During this period, have you experienced feelings of worthlessness or excessive guilt, even over trivial matters?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, how often have you experienced extreme mood swings?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the last 2 weeks, how often have you felt overly energetic or unusually irritable?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    // Add more questions here...
  ];

  Map<int, int> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bipolar Test'),
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

          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
                'bipolarTestScore': totalScore,
                'timestamp': Timestamp.now(),
              });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Test Result'),
                    content: Text('Total Score: $totalScore'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(testName: 'Bipolar Test'),
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
