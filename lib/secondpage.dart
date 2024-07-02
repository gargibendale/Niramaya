import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set white background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Add the image
              Center(
                child: Image.asset('assets/second.png'),
              ),
              const SizedBox(height: 30),
              Text(
                'Feeling down? Talk to a friendly AI companion 24/7 for support and encouragement.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49243E), // Text color
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Decode your moods! Analyze your diary entries to identify patterns and what makes you feel good.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49243E), // Text color
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Fun alert! Play the "Guess My Mood" game and test your emotional intelligence with a laugh.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49243E), // Text color
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Complete the mental health assessments to gain insights into your well-being.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49243E), // Text color
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Track your sleep and medications (optional) to see how they impact your overall health.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49243E), // Text color
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
