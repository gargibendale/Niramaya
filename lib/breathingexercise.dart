import 'package:flutter/material.dart';
import 'package:nirmaya/exercisedetailpage.dart';

class ExerciseSelectionPage extends StatelessWidget {
  final List<Exercise> exercises = [
    Exercise(
      title: 'Breathing Exercise',
      description: 'Practice deep breathing to relax and reduce stress.',
      youtubeLink: 'https://www.youtube.com/watch?v=example',
    ),
    Exercise(
      title: 'Mindfulness Meditation',
      description: 'Focus on the present moment to improve mental clarity.',
      youtubeLink: 'https://www.youtube.com/watch?v=example',
    ),
    Exercise(
      title: 'Progressive Muscle Relaxation',
      description: 'Systematically tense and relax muscles to release tension.',
      youtubeLink: 'https://www.youtube.com/watch?v=example',
    ),
    // Add more exercises as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Selection'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exercises[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseDetailsPage(exercise: exercises[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Exercise {
  final String title;
  final String description;
  final String youtubeLink;

  Exercise({
    required this.title,
    required this.description,
    required this.youtubeLink,
  });
}
