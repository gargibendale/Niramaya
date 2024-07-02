import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class OCDTestScreen extends StatefulWidget {
  const OCDTestScreen({super.key});

  @override
  _OCDTestScreenState createState() => _OCDTestScreenState();
}

class _OCDTestScreenState extends State<OCDTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Do you experience unwanted, intrusive thoughts, images, or urges that feel difficult to control?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do these thoughts or urges cause you significant anxiety or distress?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do you find yourself spending a lot of time thinking about these intrusive thoughts and their meaning?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do you feel the need to repeatedly perform certain behaviors or mental acts (compulsions) in response to your intrusive thoughts?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do these compulsions (washing hands, counting, praying, etc.) help reduce your anxiety, even though you know they may not be logical?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do you spend a significant amount of time each day engaged in these compulsive behaviors?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do your obsessions and compulsions interfere with your daily routine, work, social life, or relationships?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do you avoid certain situations or objects because they trigger your intrusive thoughts or compulsions?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do you feel significant distress or impairment in your life due to your OCD symptoms?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question':
          'Do you try to resist your obsessions or compulsions, but find it very difficult?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
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

  void checkIfTestTaken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        if (docSnapshot.exists && docSnapshot.data()!['OCDTestScore'] != null) {
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
        title: const Text('OCD Test'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: testTaken
          ? Center(
              child: Text(
                'You have already taken the OCD test.',
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
                                title: Text(questions[index]['options']
                                    [optionIndex]['option']),
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
          String diagnosis;
          if (totalScore == 0) {
            diagnosis = 'No OCD';
          } else if (totalScore <= 4) {
            diagnosis = 'Minimal OCD';
          } else if (totalScore <= 8) {
            diagnosis = 'Mild OCD';
          } else if (totalScore <= 14) {
            diagnosis = 'Moderate OCD';
          } else if (totalScore <= 20) {
            diagnosis = 'Moderately severe OCD';
          } else {
            diagnosis = 'Severe OCD';
          }

          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final docRef =
                  FirebaseFirestore.instance.collection('Users').doc(user.uid);

              // Fetch the existing document to preserve other test results
              final docSnapshot = await docRef.get();
              Map<String, dynamic>? existingData =
                  docSnapshot.data() as Map<String, dynamic>?;

              // Update the document with OCD test result while preserving other test results
              await docRef.set({
                if (existingData != null)
                  ...existingData, // Spread the existing data if not null
                'OCDTestScore': totalScore,
                'OCDDiagnosis': diagnosis,
                'OCDTestTimestamp': Timestamp.now(),
              });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Test Result'),
                    content:
                        Text('Total Score: $totalScore\nDiagnosis: $diagnosis'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(testName: 'OCD Test'),
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
