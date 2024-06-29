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

  final Map<int, int> answers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADHD Test'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question['question'],
                  style: TextStyle(fontSize: 18.0),
                ),
                ...question['options'].map<Widget>((option) {
                  return RadioListTile(
                    title: Text(option['option']),
                    value: option['points'],
                    groupValue: answers[index],
                    onChanged: (value) {
                      setState(() {
                        answers[index] = value as int;
                      });
                    },
                  );
                }).toList(),
                Divider(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              int totalPoints = answers.values.fold(0, (sum, value) => sum + value);
              final User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

                // Save the ADHD test result to Firestore
                await userRef.set({
                  'adhdTestScore': totalPoints,
                  'adhdTestAverage': totalPoints / questions.length,
                  'adhdDiagnosis': totalPoints / questions.length >= 2 ? 'Yes' : 'No',
                  'recentTestType': 'ADHD',
                  'recentTestScore': totalPoints,
                }, SetOptions(merge: true));
              }

              // Navigate back to the ProfilePage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(testName: 'ADHD'),
                ),
              );
            },
            child: Text('Submit'),
          ),
        ),
      ),
    );
  }
}
