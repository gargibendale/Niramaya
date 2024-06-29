import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nirmaya/chat.dart';
import 'package:nirmaya/detect_emo_web.dart';
import 'package:nirmaya/home.dart';
import 'package:nirmaya/tracker.dart';
import 'diary_entry.dart';
import 'main.dart'; // Import the main.dart where the notification functionality is implemented

class ProfilePage extends StatelessWidget {
  final String testName;

  ProfilePage({required this.testName});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile Page'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Text('User not logged in.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => handleMenuItemClick(item, context),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text('Take Test'),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('Chat with Bot'),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text('Guess My Mood'),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text('Set Notifications'), // New option added
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Text('Analyze my diary'), // New option added
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('Users').doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error fetching user data: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return Center(child: Text('No data found.'));
          }
          print('Fetched user data: $data');

          // Fetch anxiety test details
          int anxietyTestScore = data['anxietyTestScore'] ?? 0;
          double anxietyTestAvg = data['anxietyTestAverage'] ?? 0.0;
          String anxietyDiagnosis = data['anxietyDiagnosis'] ?? '';

          // Fetch ADHD test details
          int adhdTestScore = data['adhdTestScore'] ?? 0;
          double adhdTestAvg = data['adhdTestAverage'] ?? 0.0;
          String adhdDiagnosis = data['adhdDiagnosis'] ?? '';

          // Fetch depression test details
          int depressionTestScore = data['DepressionTestScore'] ?? 0;
          double depressionTestAverage = data['DepressionTestAverage'] ?? 0.0;
          String depressionDiagnosis = data['depressionDiagnosis'] ?? '';

          // Fetch bipolar test details
          int bipolarTestScore = data['bipolarTestScore'] ?? 0;
          // Add more fields as needed for bipolar test

          // Fetch eating disorder test details
          int eatingDisorderTestScore = data['eatingDisorderTestScore'] ?? 0;
          String eatingDisorderDiagnosis =
              data['eatingDisorderDiagnosis'] ?? '';

          // Fetch OCD test details
          int ocdTestScore = data['OCDTestScore'] ?? 0;

          // Fetch PTSD test details
          int ptsdTestScore = data['PTSDTestScore'] ?? 0;

          // Fetch stress test details
          int stressTestScore = data['StressTestScore'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                if (anxietyTestScore != 0 || anxietyDiagnosis.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Anxiety Test Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildTestResult(
                          'Anxiety Test', anxietyTestScore, anxietyDiagnosis,
                          average: anxietyTestAvg),
                      SizedBox(height: 20),
                    ],
                  ),
                if (adhdTestScore != 0 || adhdDiagnosis.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ADHD Test Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildTestResult('ADHD Test', adhdTestScore, adhdDiagnosis,
                          average: adhdTestAvg),
                      SizedBox(height: 20),
                    ],
                  ),
                if (depressionTestScore != 0 || depressionDiagnosis.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Depression Test Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildTestResult('Depression Test', depressionTestScore,
                          depressionDiagnosis,
                          average: depressionTestAverage),
                      SizedBox(height: 20),
                    ],
                  ),
                if (bipolarTestScore != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bipolar Test Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildTestResult('Bipolar Test', bipolarTestScore, ''),
                      SizedBox(height: 20),
                    ],
                  ),
                if (eatingDisorderTestScore != 0 ||
                    eatingDisorderDiagnosis.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Eating Disorder Test Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildTestResult('Eating Disorder Test',
                          eatingDisorderTestScore, eatingDisorderDiagnosis),
                      SizedBox(height: 20),
                    ],
                  ),
                if (ocdTestScore != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('OCD Test Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildTestResult('OCD Test', ocdTestScore, ''),
                      SizedBox(height: 20),
                    ],
                  ),
                if (ptsdTestScore != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PTSD Test Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildTestResult('PTSD Test', ptsdTestScore, ''),
                      SizedBox(height: 20),
                    ],
                  ),
                if (stressTestScore != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stress Test Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildTestResult('Stress Test', stressTestScore, ''),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTestResult(String testName, int score, String diagnosis,
      {double average = 0.0}) {
    if (score == 0 && diagnosis.isEmpty) {
      return SizedBox
          .shrink(); // Return an empty SizedBox if both score and diagnosis are empty
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$testName:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        if (score != 0) Text('Score: $score'),
        if (average != 0.0) Text('Average: ${average.toStringAsFixed(2)}'),
        if (diagnosis.isNotEmpty) Text('Diagnosis: $diagnosis'),
        SizedBox(height: 10),
      ],
    );
  }

  void handleMenuItemClick(int item, BuildContext context) {
    switch (item) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetectEmotion()),
        );
        break;
      case 3: // New case for notifications
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TrackerPage()), // Navigate to the notifications page
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DiaryEntryScreen()), // Navigate to the notifications page
        );
        break;
    }
  }
}
