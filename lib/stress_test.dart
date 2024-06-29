import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class StressTestScreen extends StatefulWidget {
  const StressTestScreen({super.key});

  @override
  _StressTestScreenState createState() => _StressTestScreenState();
}

class _StressTestScreenState extends State<StressTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Do you often feel overwhelmed, anxious, or irritable?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you experience frequent feelings of sadness, hopelessness, or low mood?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you have difficulty concentrating or making decisions due to feeling stressed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you experience headaches, muscle tension, or stomachaches more frequently when stressed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you have trouble sleeping or staying asleep due to stress?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you notice changes in your appetite (increased or decreased) when stressed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you find yourself using unhealthy coping mechanisms like smoking, drinking, or overeating to deal with stress?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you isolate yourself from social activities or withdraw from loved ones when stressed?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you have difficulty relaxing or taking time for yourself due to feeling constantly on edge?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you find yourself procrastinating on tasks or neglecting responsibilities due to feeling overwhelmed?',
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
        if (docSnapshot.exists && docSnapshot.data()!['StressTestScore'] != null) {
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
        title: const Text('Stress Test'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      
       body: testTaken
          ? Center(
              child: Text(
                'You have already taken the stress test.',
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
        onPressed: () async {
          int totalScore = 0;
          selectedOptions.forEach((key, value) {
            totalScore += value;
          });

          String diagnosis;
                if (totalScore == 0) {
                  diagnosis = 'No Stress';
                } else if (totalScore <= 4) {
                  diagnosis = 'Minimal Stress';
                } else if (totalScore <= 8) {
                  diagnosis = 'Mild Stress';
                } else if (totalScore <= 14) {
                  diagnosis = 'Moderate Stress';
                } else if (totalScore <= 20) {
                  diagnosis = 'Moderately severe Stress';
                } else {
                  diagnosis = 'Severe Stress';
                }
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

              await FirebaseFirestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot = await transaction.get(userDocRef);

                if (!snapshot.exists) {
                  throw Exception("User document does not exist!");
                }

                Map<String, dynamic> existingData = snapshot.data() as Map<String, dynamic>;
                existingData['StressTestScore'] = totalScore;
                existingData['StressDiagnosis'] = diagnosis;
                existingData['timestamp'] = Timestamp.now();

                transaction.update(userDocRef, existingData);
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
                              builder: (context) => ProfilePage(testName: 'Stress Test'),
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
