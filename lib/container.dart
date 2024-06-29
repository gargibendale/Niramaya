import 'package:flutter/material.dart';
import 'chat.dart';
import 'diary_entry.dart';
import 'detect_emo_web.dart';
import 'home.dart';
import 'helpline.dart';
import 'profile.dart';

class ContainerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Humanoid Chatbot',
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

  Widget _buildGridButton(BuildContext context, String title, Widget? destination) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.all(30.0), // Reduce padding to fit text better
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
