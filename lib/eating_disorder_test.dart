import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';

class EatingDisorderTestScreen extends StatefulWidget {
  const EatingDisorderTestScreen({super.key});

  @override
  _EatingDisorderTestScreenState createState() => _EatingDisorderTestScreenState();
}

class _EatingDisorderTestScreenState extends State<EatingDisorderTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Do you find yourself preoccupied with food or weight loss most of the time, even when you\'re not eating?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you often skip meals or restrict your food intake even when you\'re feeling hungry?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you purge after eating through methods like vomiting, laxatives, or excessive exercise to avoid weight gain?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you eat large amounts of food in a short period of time (binge eating) even when you\'re not hungry, followed by feelings of guilt or shame?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you see yourself as overweight or fat even when you\'re objectively underweight?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Is your self-worth heavily influenced by your weight or body shape?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you constantly feel the need to control your weight and food intake?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you use food or restricting food intake as a way to cope with stress or difficult emotions?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Do you isolate yourself from social activities or avoid eating in public due to anxiety about your food choices or body image?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    {
      'question': 'Have you noticed changes in your health, such as fatigue, hair loss, or irregular periods, but avoid seeking medical help due to fear of weight gain?',
      'options': [
        {'option': 'Never', 'points': 0},
        {'option': 'Sometimes', 'points': 1},
        {'option': 'Often', 'points': 2},
        {'option': 'Everyday', 'points': 3},
      ],
    },
    // ... other questions ...
  ];

  Map<int, int> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eating Disorder Test'),
        centerTitle: true,
        backgroundColor: Colors.pink,
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
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
                'eatingDisorderTestScore': totalScore,
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
                              builder: (context) => ProfilePage(testName: 'Eating Disorder Test'),
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
