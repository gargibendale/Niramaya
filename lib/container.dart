import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nirmaya/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat.dart';
import 'diary_entry.dart';
import 'detect_emo_web.dart';
import 'home.dart';
import 'helpline.dart';
import 'profile.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  signOutUser() async {
    await FirebaseAuth.instance.signOut().then((value) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOutUser();
        },
        child: Icon(Icons.logout_sharp),
      ),
      body: Container(
        color: Color(0xFFFFF9C4), // Set background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1 / 1, // Adjust aspect ratio to reduce height
            children: <Widget>[
              _buildGridButton(
                context,
                'Chat with Dawn',
                ChatPage(),
              ),
              _buildGridButton(
                context,
                'Dairy Analysis',
                DiaryEntryScreen(),
              ),
              _buildGridButton(
                context,
                'Guess My MOOD',
                DetectEmotion(),
              ),
              _buildGridButton(
                context,
                'Survey Based Diagnosis',
                HomeScreen(),
              ),
              _buildGridButton(
                context,
                'Helpline Numbers',
                Helpline(),
              ),
              _buildGridButton(
                context,
                'Profile Page',
                HomeScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, String title, Widget? destination) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding:
            const EdgeInsets.all(30.0), // Reduce padding to fit text better
      ),
      onPressed: () {
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        } else {
          // Show a message if the screen is not available
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Screen not available')),
          );
        }
      },
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18, // Increase text size
          ),
        ),
      ),
    );
  }
}
