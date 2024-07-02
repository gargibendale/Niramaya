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
      'question':
          'Over the last 2 weeks, how often have you felt nervous, anxious, or on edge?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, how often have you been unable to stop or control worrying?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, have you felt restless or on edge, unable to relax?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'A little', 'points': 1},
        {'option': 'Quite a bit', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, have you been easily tired or fatigued?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, have you been having difficulty concentrating on things, such as reading the newspaper or watching television?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, have you been so worried that you have trouble falling or staying asleep?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, have you been irritable or on edge with people?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, have you been afraid that something awful is going to happen?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'All the time', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, have you avoided places or situations that might cause you to worry?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'Occasionally', 'points': 1},
        {'option': 'Frequently', 'points': 2},
        {'option': 'All the time', 'points': 3},
      ],
    },
    {
      'question':
          'Over the last 2 weeks, have you had difficulty controlling your worries that have made it hard to get things done at work, school or home?',
      'options': [
        {'option': 'Not at all', 'points': 0},
        {'option': 'To some degree', 'points': 1},
        {'option': 'To a considerable degree', 'points': 2},
        {'option': 'Very much', 'points': 3},
      ],
    },
  ];

  Map<int, int> selectedOptions = {};
  bool testTaken = false; // Flag to track if the test has been taken

  @override
  void initState() {
    super.initState();
    checkIfTestTaken(); // Check if the test has been taken before
  }

  // Method to check if the user has already taken the test
  void checkIfTestTaken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        if (docSnapshot.exists &&
            docSnapshot.data()!['AnxietyTestScore'] != null) {
          setState(() {
            testTaken = true;
          });
        }
      } catch (e) {
        print('Error checking test status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Anxiety Test',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFFFF8E3),
      ),
      backgroundColor: const Color(0xFFF5EEE6),
      body: testTaken
          ? Center(
              child: Text(
                'You have already taken the anxiety test.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  color: Colors.purple.shade100,
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
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(
                            questions[index]['options'].length,
                            (optionIndex) {
                              return RadioListTile<int>(
                                title: Text(
                                  questions[index]['options'][optionIndex]
                                      ['option'],
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: questions[index]['options'][optionIndex]
                                    ['points'],
                                groupValue: selectedOptions[index],
                                activeColor: Colors.black,
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
        onPressed: testTaken
            ? null // Disable FAB if the test has been taken
            : () async {
                int totalScore = 0;
                selectedOptions.forEach((key, value) {
                  totalScore += value;
                });

                String diagnosis;
                if (totalScore == 0) {
                  diagnosis = 'No anxiety';
                } else if (totalScore <= 4) {
                  diagnosis = 'Minimal anxiety';
                } else if (totalScore <= 8) {
                  diagnosis = 'Mild anxiety';
                } else if (totalScore <= 14) {
                  diagnosis = 'Moderate anxiety';
                } else if (totalScore <= 20) {
                  diagnosis = 'Moderately severe anxiety';
                } else {
                  diagnosis = 'Severe anxiety';
                }

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .update({
                      'AnxietyTestScore': totalScore,
                      'AnxietyDiagnosis': diagnosis,
                      'Timestamp': Timestamp.now(),
                    });

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Test Result'),
                          content: Text(
                              'Total Score: $totalScore\nDiagnosis: $diagnosis'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePage(testName: 'Anxiety Test'),
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
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.black,
      ),
    );
  }
}
