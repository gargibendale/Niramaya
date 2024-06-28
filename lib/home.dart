import 'package:flutter/material.dart';
import 'package:nirmaya/deptest.dart';

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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // General Information Section
              const Expanded(
                flex: 2,
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
                    SizedBox(height: 10),
                    Text(
                      'Mental health is essential for our overall well-being. Here, you can take various tests to assess your mental health condition. Below are some of the tests you can take:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Mental Health Tests Section
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    return Card(
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
              // Footer Section with Health Line Numbers
              const Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Divider(),
                    Text(
                      'Health Line Numbers:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Mental Health Helpline: 123-456-7890'),
                    Text('Suicide Prevention Line: 987-654-3210'),
                    Text('Emergency Services: 112'),
                  ],
                ),
              ),
            ],
          ),
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
    },
  ));
}



// Similarly, create other test screens (AnxietyTestScreen, OCDTestScreen, etc.)
