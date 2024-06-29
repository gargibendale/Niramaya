import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nirmaya/chat.dart';
import 'package:nirmaya/detect_emotion.dart';
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

          // Calculate the diagnosis
          String diagnosis = '';
          int totalScore = data['totalScore'];
          if (totalScore >= 3 && totalScore <= 4) {
            diagnosis = 'Minimal level of $testName';
          } else if (totalScore >= 5 && totalScore <= 9) {
            diagnosis = 'Mild level of $testName';
          } else if (totalScore >= 10 && totalScore <= 14) {
            diagnosis = 'Moderate level of $testName';
          } else if (totalScore >= 15 && totalScore <= 19) {
            diagnosis = 'Moderately Severe level of $testName';
          } else if (totalScore >= 20 && totalScore <= 27) {
            diagnosis = 'Severe level of $testName';
          }

          // Save the diagnosis to Firestore
          FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
            'diagnosis': diagnosis,
          }).catchError((error) {
            print('Error saving diagnosis: $error');
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test Score: $totalScore',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Diagnosis: $diagnosis',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
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
          MaterialPageRoute(builder: (context) => EmotionDetectionPage()),
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
