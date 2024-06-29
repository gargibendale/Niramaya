import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'camera_service.dart';
import 'package:provider/provider.dart';

class EmotionDetectionPage extends StatefulWidget {
  @override
  _EmotionDetectionPageState createState() => _EmotionDetectionPageState();
}

class _EmotionDetectionPageState extends State<EmotionDetectionPage> {
  Map<String, String?> responses = {};
  int currentQuestionIndex = 0;
  String detectedEmotion = '';

  var questions = [
    {
      'emotion': 'surprise',
      'question':
          'You open your fridge and find a birthday cake inside (even though it\'s not your birthday)! '
    },
    {
      'emotion': 'happy',
      'question': 'You see a funny animal video online and laugh out loud. '
    },
    {
      'emotion': 'happy',
      'question': 'You get a text from a friend asking to hang out. '
    },
    {
      'emotion': 'sad',
      'question': 'You lose your favorite pair of socks in the laundry. '
    },
    {
      'emotion': 'sad',
      'question': 'It\'s raining on the day you planned a picnic in the park. '
    },
    {
      'emotion': 'neutral',
      'question':
          'You\'re waiting in line at the bank and someone holds the door for you. '
    },
    {
      'emotion': 'neutral',
      'question':
          'You\'re walking down the street and see someone wearing a cool outfit. '
    },
    {
      'emotion': 'angry',
      'question': 'Someone bumps into you and doesn\'t apologize. '
    },
    {
      'emotion': 'angry',
      'question':
          'Your phone battery dies right when you need to make an important call.'
    },
    {'emotion': 'fear', 'question': 'You see a spider crawling on the wall. '}
  ];

  void _calculateAverageMood(BuildContext context) {
    Map<String, int> emotionScores = {
      'surprise': 4,
      'happy': 5,
      'neutral': 3,
      'sad': 2,
      'angry': 1,
      'fear': 2,
    };

    int totalScore = 0;
    int count = 0;

    responses.forEach((emotion, response) {
      if (response != null) {
        totalScore += emotionScores[response]!;
        count++;
      }
    });

    double averageScore = count > 0 ? totalScore / count : 0.0;

    String averageMood;
    if (averageScore >= 4.5) {
      averageMood = 'Very Positive';
    } else if (averageScore >= 3.5) {
      averageMood = 'Positive';
    } else if (averageScore >= 2.5) {
      averageMood = 'Neutral';
    } else if (averageScore >= 1.5) {
      averageMood = 'Negative';
    } else {
      averageMood = 'Very Negative';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Average Mood'),
          content: Text('Average mood: $averageMood'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _askNextQuestion(BuildContext context, CameraService cameraService) {
    if (currentQuestionIndex < questions.length) {
      String question = questions[currentQuestionIndex]['question']!;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          // Use a different context here
          return AlertDialog(
            title: Text('Question ${currentQuestionIndex + 1}'),
            content: Text(question),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(
                      dialogContext); // Use dialogContext to close the dialog
                  String? emotion =
                      await _captureAndDetectEmotion(context, cameraService);
                  if (emotion != null) {
                    responses[questions[currentQuestionIndex]['emotion']!] =
                        emotion;
                    currentQuestionIndex++;
                    _askNextQuestion(context, cameraService);
                  }
                },
                child: Text('Answer with Emotion'),
              ),
            ],
          );
        },
      );
    } else {
      _calculateAverageMood(context);
    }
  }

  Future<String?> _captureAndDetectEmotion(
      BuildContext context, CameraService cameraService) async {
    try {
      XFile picture = await cameraService.controller!.takePicture();
      Uint8List imageBytes = await picture.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      var response = await http.post(
        Uri.parse(
            'https://914c-2401-4900-7c6a-3aa1-9856-e899-4358-332a.ngrok-free.app/api/detect_emotion/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          detectedEmotion = jsonResponse['message'];
        });
        return jsonResponse['message'];
      } else {
        _showEmotionDialog(context, 'Failed to detect emotion');
        return null;
      }
    } catch (e) {
      _showEmotionDialog(context, 'Error: $e');
      return null;
    }
  }

  void _startQuestionnaire(BuildContext context, CameraService cameraService) {
    currentQuestionIndex = 0;
    responses.clear();
    _askNextQuestion(context, cameraService);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraService(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Emotion Detection'),
        ),
        body: Consumer<CameraService>(
          builder: (context, cameraService, child) {
            if (cameraService.controller == null ||
                !cameraService.controller!.value.isInitialized) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Center(
                  child: ClipRRect(
                    child: SizedOverflowBox(
                      size: const Size(400, 500), // aspect is 4:3
                      alignment: Alignment.center,
                      child: CameraPreview(cameraService.controller!),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera),
                      onPressed: () =>
                          _captureAndDetectEmotion(context, cameraService),
                    ),
                    IconButton(
                      icon: Icon(Icons.switch_camera),
                      onPressed: () => cameraService.switchCamera(),
                    ),
                    IconButton(
                      icon: Icon(Icons.question_answer),
                      onPressed: () =>
                          _startQuestionnaire(context, cameraService),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    detectedEmotion.isNotEmpty
                        ? 'Detected Emotion: $detectedEmotion'
                        : 'Mood',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showEmotionDialog(BuildContext context, String emotion) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Emotion Detection Result'),
          content: Text(emotion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
