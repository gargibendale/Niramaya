import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class PTSDTestScreen extends StatefulWidget {
  const PTSDTestScreen({super.key});

  @override
  _PTSDTestScreenState createState() => _PTSDTestScreenState();
}

class _PTSDTestScreenState extends State<PTSDTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Do you have repeated nightmares or flashbacks about the traumatic event?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you experience intense emotional distress or physical reactions (sweating, rapid heart rate) when reminded of the event?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you avoid places, people, or situations that remind you of the traumatic event?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you find it difficult to talk about the traumatic event or anything related to it?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you have difficulty remembering important aspects of the traumatic event?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you have negative beliefs about yourself or the world as a result of the trauma (e.g., feeling worthless, believing the world is dangerous)?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you experience a persistent inability to experience positive emotions (anhedonia)?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you feel constantly on edge or hypervigilant, scanning your surroundings for danger?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you have trouble sleeping or staying asleep due to intrusive thoughts or nightmares?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you experience exaggerated startle responses or irritability or outbursts of anger?',
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

  // Method to check if the user has already taken the test
  void checkIfTestTaken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
        if (docSnapshot.exists && docSnapshot.data()!['PTSDTestScore'] != null) {
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
        title: const Text('PTSD Test'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: testTaken
          ? Center(
              child: Text(
                'You have already taken the PTSD test.',
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
        onPressed: testTaken
            ? null // Disable FAB if the test has been taken
            : () async {
                int totalScore = 0;
                selectedOptions.forEach((key, value) {
                  totalScore += value;
                });

                String diagnosis;
                if (totalScore == 0) {
                  diagnosis = 'No PTSD';
                } else if (totalScore <= 4) {
                  diagnosis = 'Minimal PTSD';
                } else if (totalScore <= 8) {
                  diagnosis = 'Mild PTSD';
                } else if (totalScore <= 14) {
                  diagnosis = 'Moderate PTSD';
                } else if (totalScore <= 20) {
                  diagnosis = 'Moderately severe PTSD';
                } else {
                  diagnosis = 'Severe PTSD';
                }

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final docRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

                    // Fetch the existing document to preserve other test results
                    final docSnapshot = await docRef.get();
                    Map<String, dynamic>? existingData = docSnapshot.data() as Map<String, dynamic>?;

                    // Update the document with PTSD test result while preserving other test results
                    await docRef.set({
                      if (existingData != null) ...existingData, // Spread the existing data if not null
                      'PTSDTestScore': totalScore,
                      'PTSDDiagnosis': diagnosis,
                      'PTSDTestTimestamp': Timestamp.now(),
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
                                    builder: (context) => ProfilePage(testName: 'PTSD Test'),
                                  ),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );

                    setState(() {
                      testTaken = true; // Update the flag to indicate the test has been taken
                    });
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
