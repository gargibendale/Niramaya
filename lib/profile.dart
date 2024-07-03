import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niramaya/container.dart';

class ProfilePage extends StatelessWidget {
  final String testName;

  ProfilePage({required this.testName});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          centerTitle: true,
          backgroundColor: const Color(0xFFFFF9C4),
        ),
        body: const Center(
          child: Text('User not logged in.',
              style: TextStyle(color: Colors.black)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF9C4),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('Users').doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error fetching user data: ${snapshot.error}');
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.black)));
          }

          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return const Center(
                child: Text('No data found.',
                    style: TextStyle(color: Colors.black)));
          }
          print('Fetched user data: $data');

          String email = data['email'] ?? 'No email available';
          String firstName = data['firstName'] ?? 'No first name available';
          String lastName = data['lastName'] ?? 'No last name available';

          String fullName = firstName + ' ' + lastName;

          // Fetch test details
          int anxietyTestScore = data['AnxietyTestScore'] ?? 0;
          String anxietyDiagnosis = data['AnxietyDiagnosis'] ?? '';
          int adhdTestScore = data['ADHDTestScore'] ?? 0;
          String adhdDiagnosis = data['ADHDDiagnosis'] ?? '';
          int depressionTestScore = data['DepressionTestScore'] ?? 0;
          String depressionDiagnosis = data['DepressionDiagnosis'] ?? '';
          int bipolarTestScore = data['BipolarTestScore'] ?? 0;
          String bipolarDiagnosis = data['BipolarDiagnosis'] ?? '';
          int eatingDisorderTestScore = data['EatingDisorderTestScore'] ?? 0;
          String eatingDisorderDiagnosis =
              data['EatingDisorderDiagnosis'] ?? '';
          int ocdTestScore = data['OCDTestScore'] ?? 0;
          String ocdDiagnosis = data['OCDDiagnosis'] ?? '';
          int ptsdTestScore = data['PTSDTestScore'] ?? 0;
          String ptsdDiagnosis = data['PTSDDiagnosis'] ?? '';
          int stressTestScore = data['StressTestScore'] ?? 0;
          String stressDiagnosis = data['StressDiagnosis'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Display the uploaded image
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Color.fromARGB(255, 97, 0, 0),
                  foregroundColor: Colors.white,
                  child: Center(
                    child: Text(firstName[0],
                        style: TextStyle(
                            fontSize: 55, fontWeight: FontWeight.bold)),
                  ),
                ), // Make sure to add this asset in pubspec.yaml

                const SizedBox(height: 20),

                Text('Email: $email',
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
                Text('Name: $fullName',
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 20),
                if (anxietyTestScore != 0 || anxietyDiagnosis.isNotEmpty)
                  buildTestResult(
                      'Anxiety Test', anxietyTestScore, anxietyDiagnosis),
                if (adhdTestScore != 0 || adhdDiagnosis.isNotEmpty)
                  buildTestResult('ADHD Test', adhdTestScore, adhdDiagnosis),
                if (depressionTestScore != 0 || depressionDiagnosis.isNotEmpty)
                  buildTestResult('Depression Test', depressionTestScore,
                      depressionDiagnosis),
                if (bipolarTestScore != 0 || bipolarDiagnosis.isNotEmpty)
                  buildTestResult(
                      'Bipolar Test', bipolarTestScore, bipolarDiagnosis),
                if (eatingDisorderTestScore != 0 ||
                    eatingDisorderDiagnosis.isNotEmpty)
                  buildTestResult('Eating Disorder Test',
                      eatingDisorderTestScore, eatingDisorderDiagnosis),
                if (ocdTestScore != 0 || ocdDiagnosis.isNotEmpty)
                  buildTestResult('OCD Test', ocdTestScore, ocdDiagnosis),
                if (ptsdTestScore != 0 || ptsdDiagnosis.isNotEmpty)
                  buildTestResult('PTSD Test', ptsdTestScore, ptsdDiagnosis),
                if (stressTestScore != 0 || stressDiagnosis.isNotEmpty)
                  buildTestResult(
                      'Stress Test', stressTestScore, stressDiagnosis),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContainerScreen()),
                    );
                  },
                  child: const Text('Home'),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildTestResult(String testName, int score, String diagnosis,
      {double average = 0.0}) {
    if (score == 0 && diagnosis.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$testName:',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        const SizedBox(height: 5),
        if (score != 0)
          Text('Score: $score', style: const TextStyle(color: Colors.black)),
        if (average != 0.0)
          Text('Average: ${average.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.black)),
        if (diagnosis.isNotEmpty)
          Text('Diagnosis: $diagnosis',
              style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 10),
      ],
    );
  }
}
