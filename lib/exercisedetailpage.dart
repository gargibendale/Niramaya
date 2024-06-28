import 'package:flutter/material.dart';
import 'package:nirmaya/breathingexercise.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final Exercise exercise;

  ExerciseDetailsPage({required this.exercise});

  Future<void> _launchYouTubeVideo() async {
    String url = exercise.youtubeLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.description,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _launchYouTubeVideo,
              child: Text('Watch Exercise Video'),
            ),
          ],
        ),
      ),
    );
  }
}
