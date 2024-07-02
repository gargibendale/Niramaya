import 'package:flutter/material.dart';
import 'container.dart'; // Import ContainerScreen

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Set white background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/thirdpage.png',
                height: 300,
              ),
              const SizedBox(height: 20),
              Text(
                'Remember, Niramaya is a self-care app.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49243E), // Title color
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'If you feel you need additional support, it\'s always recommended to consult with a licensed mental health professional.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFE0A75E), // Answer color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ContainerScreen()),
                  );
                },
                child: Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
