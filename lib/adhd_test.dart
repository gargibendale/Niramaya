import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class ADHDTestScreen extends StatefulWidget {
  const ADHDTestScreen({super.key});

  @override
  _ADHDTestScreenState createState() => _ADHDTestScreenState();
}

class _ADHDTestScreenState extends State<ADHDTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Over the past 2 weeks, have you often found your mind drifting off or daydreaming during lectures, conversations, or while reading?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Have you often struggled to complete or hand in schoolwork, chores, or other workplace tasks on time due to forgetfulness or difficulty staying focused?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you frequently lose track of conversations, appointments, or objects you need (e.g., keys, phone, wallet)?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you often have difficulty following instructions or finishing tasks that require sustained mental effort?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the past 2 weeks, have you often felt restless or fidgety, unable to sit still for extended periods?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you often blurt out answers before someone finishes asking a question, or interrupt conversations?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you often feel a sense of urgency or like you need to be doing something, even when relaxing?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Have you found it challenging to organize tasks or activities, often underestimating the time required to complete them?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Over the past 2 weeks, have you had trouble waiting your turn in situations such as lines or group activities?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you frequently start new tasks before finishing the ones you already began?',
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
        final docSnapshot = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
        if (docSnapshot.exists && docSnapshot.data()!['ADHDTestScore'] != null) {
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
          'ADHD Test',
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
                'You have already taken the ADHD test.',
                style: TextStyle(fontSize: 18, color: Colors.black), // Changed to black
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
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(
                            questions[index]['options'].length,
                            (optionIndex) {
                              return RadioListTile<int>(
                                title: Text(
                                  questions[index]['options'][optionIndex]['option'],
                                  style: const TextStyle(color: Colors.black), // Changed to black
                                ),
                                value: questions[index]['options'][optionIndex]['points'],
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
        onPressed: () async {
          int totalScore = 0;
          selectedOptions.forEach((key, value) {
            totalScore += value;
          });
          String diagnosis;
          if (totalScore == 0) {
            diagnosis = 'No ADHD';
          } else if (totalScore <= 4) {
            diagnosis = 'Minimal ADHD';
          } else if (totalScore <= 8) {
            diagnosis = 'Mild ADHD';
          } else if (totalScore <= 14) {
            diagnosis = 'Moderate ADHD';
          } else if (totalScore <= 20) {
            diagnosis = 'Moderately severe ADHD';
          } else {
            diagnosis = 'Severe ADHD';
          }

          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final docRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

              // Fetch the existing document to preserve other test results
              final docSnapshot = await docRef.get();
              Map<String, dynamic>? existingData = docSnapshot.data() as Map<String, dynamic>?;

              // Update the document with ADHD test result while preserving other test results
              await docRef.set({
                if (existingData != null) ...existingData, // Spread the existing data if not null
                'ADHDTestScore': totalScore,
                'ADHDDiagnosis': diagnosis,
                'ADHDTestTimestamp': Timestamp.now(),
              });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Test Result'),
                    content: Text('Total Score: $totalScore\nDiagnosis: $diagnosis'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(testName: 'ADHD Test'),
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
