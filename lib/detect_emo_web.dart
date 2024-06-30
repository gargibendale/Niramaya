import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:convert';

class DetectEmotion extends StatefulWidget {
  @override
  _DetectEmotionState createState() => _DetectEmotionState();
}

class _DetectEmotionState extends State<DetectEmotion> {
  final ImagePicker _picker = ImagePicker();
  String recognizedEmo = '';
  CameraController? _cameraController;
  XFile? _image;

  final List<Map<String, String>> questions = [
    {
      'emotion': 'surprise',
      'question':
          'You open your fridge and find a birthday cake inside (even though it\'s not your birthday)! '
    },
    {
      'emotion': 'happy',
      'question': 'Your friend sends you a funny animal video online '
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

  Map<String, XFile?> responses = {
    'surprise': null,
    'happy': null,
    'sad': null,
    'neutral': null,
    'fear': null,
    'angry': null,
  };

  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    // Select the front camera
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(frontCamera, ResolutionPreset.high);
    await _cameraController!.initialize();
    _askNextQuestion();
  }

  Future<void> _takePicture(String emotion) async {
    final image = await _cameraController!.takePicture();
    setState(() {
      responses[emotion] = image;
    });
    _sendImageToApi(image, emotion);
  }

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _image = file;
      });
      _sendImageToApi(file, 'gallery');
    }
  }

  Future<void> _sendImageToApi(XFile image, String emotion) async {
    List<int> fileBytes = await image.readAsBytes();
    String base64String = base64Encode(fileBytes);

    try {
      final response = await http.post(
        Uri.parse(
            'https://5016-2401-4900-7c6a-3aa1-9856-e899-4358-332a.ngrok-free.app/api/detect_emotion/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64String, 'emotion': emotion}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          recognizedEmo = result['message'];
        });
      } else {
        print("Error: Server returned status code ${response.statusCode}");
        print("Response body: ${response.body}");
        setState(() {
          recognizedEmo = 'Error recognizing face';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        recognizedEmo = 'Error capturing image';
      });
    }

    await Future.delayed(Duration(seconds: 7)); // Add 7 seconds delay
    _askNextQuestion();
  }

  void _askNextQuestion() async {
    if (currentQuestionIndex < questions.length) {
      var currentQuestion = questions[currentQuestionIndex];
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Question'),
            content: Text(currentQuestion['question']!),
            actions: <Widget>[
              TextButton(
                child: Text('Capture Photo'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _takePicture(currentQuestion['emotion']!);
                },
              ),
            ],
          );
        },
      );
      currentQuestionIndex++;
    } else {
      _calculateAverageMood();
    }
  }

  void _calculateAverageMood() {
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
        totalScore += emotionScores[emotion]!;
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

    setState(() {
      recognizedEmo = 'Average mood: $averageMood';
    });
  }

  void _resetQuiz() {
    setState(() {
      recognizedEmo = '';
      currentQuestionIndex = 0;
      responses.updateAll((key, value) => null);
    });
    _askNextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion Detection'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _cameraController != null
                  ? ClipRRect(
                      child: SizedOverflowBox(
                        size: const Size(400, 500), // aspect is 4:3
                        alignment: Alignment.center,
                        child: CameraPreview(_cameraController!),
                      ),
                    )
                  : Container(),
              SizedBox(height: 16),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateAverageMood,
                child: const Text('Calculate Average Mood'),
              ),
              SizedBox(height: 16),
              Text(
                recognizedEmo,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              recognizedEmo.isNotEmpty
                  ? ElevatedButton(
                      onPressed: _resetQuiz,
                      child: const Text('Play Again'),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
