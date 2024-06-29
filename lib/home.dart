import 'package:flutter/material.dart';
import 'deptest.dart'; // Make sure to import this file as well
import 'anxiety_test.dart';
import 'ocd_test.dart';
import 'stress_test.dart';
import 'bipolar_test.dart';
import 'ptsd_test.dart';
import 'eating_disorder_test.dart';
import 'adhd_test.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> tests = [
    {'name': 'Depression Test', 'route': '/test/depression'},
    {'name': 'Anxiety Test', 'route': '/test/anxiety'},
    {'name': 'OCD Test', 'route': '/test/ocd'},
    {'name': 'Stress Test', 'route': '/test/stress'},
    {'name': 'Bipolar Disorder Test', 'route': '/test/bipolar'},
    {'name': 'PTSD Test', 'route': '/test/ptsd'},
    {'name': 'Eating Disorder Test', 'route': '/test/eating'},
    {'name': 'ADHD Test', 'route': '/test/adhd'},
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Information Section
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to the Mental Health App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Mental health is essential for our overall well-being. Here, you can take various tests to assess your mental health condition. Below are some of the tests you can take:',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            // Mental Health Tests Section
            Expanded(
              child: ListView.builder(
                itemCount: tests.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(tests[index]['name']!),
                      onTap: () {
                        Navigator.pushNamed(context, tests[index]['route']!);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    routes: {
      '/test/depression': (context) => const DepressionTestScreen(),
      '/test/anxiety': (context) => const AnxietyTestScreen(),
      '/test/ocd': (context) => const OCDTestScreen(),
      '/test/stress': (context) => const StressTestScreen(),
      '/test/bipolar': (context) => const BipolarTestScreen(),
      '/test/ptsd': (context) => const PTSDTestScreen(),
      '/test/eating': (context) => const EatingDisorderTestScreen(),
      '/test/adhd': (context) => const ADHDTestScreen(),
    },
  ));
}
