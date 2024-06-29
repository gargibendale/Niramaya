import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nirmaya/consts.dart';
import 'package:nirmaya/twtext.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _chatHistoryInternal = [
    {
      'role': 'user',
      'parts': [
        {
          'text':
              'Suppose you are not Gemini, the multimodal AI model, but a mental health advisor AI named Dawn. You suggest advice for your patients. Answer like a humanoid chat assistant with a friendly, cheerful tone. Only use English language. Reply in approximately 150 words.',
        },
      ],
    },
    {
      'role': 'model',
      'parts': [
        {
          'text': 'Sure.',
        },
      ],
    },
  ];
  final List<Map<String, String>> _chatHistoryDisplay = [];
  late GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    const apiKey = GOOGLE_API_KEY;
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  void _handleSendMessage() async {
    final message = _messageController.text;
    _messageController.clear();

    setState(() {
      _chatHistoryInternal.add({
        'role': 'user',
        'parts': [
          {'text': message}
        ],
      });
      _chatHistoryDisplay.add({'role': 'user', 'text': message});
    });

    try {
      final content = _chatHistoryInternal
          .map((entry) => Content.text(entry['parts'][0]['text']))
          .toList();
      final response = await _model.generateContent(content);

      setState(() {
        _chatHistoryInternal.add({
          'role': 'model',
          'parts': [
            {'text': response.text}
          ],
        });
        _chatHistoryDisplay
            .add({'role': 'model', 'text': response.text!.trim()});
      });
    } catch (e) {
      setState(() {
        _chatHistoryInternal.add({
          'role': 'model',
          'parts': [
            {'text': 'Error: $e'}
          ],
        });
        _chatHistoryDisplay.add({'role': 'model', 'text': 'Error: $e'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dawn'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/chatbg4.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatHistoryDisplay.length,
                itemBuilder: (context, index) {
                  final message = _chatHistoryDisplay[index]['text']!;
                  final isUserMessage =
                      _chatHistoryDisplay[index]['role'] == 'user';
                  return Row(
                    mainAxisAlignment: isUserMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Color.fromRGBO(136, 192, 255, 1)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: isUserMessage
                                ? Text(
                                    message,
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 37, 21, 65)),
                                  )
                                : TypewriterText(
                                    text: message,
                                    textStyle: TextStyle(color: Colors.black),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 12, 45),
                      ),
                      controller: _messageController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Type a message...',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 14, 43, 86))),
                    ),
                  ),
                  IconButton(
                    onPressed: _handleSendMessage,
                    icon: const Icon(Icons.send),
                    color: const Color.fromARGB(255, 10, 50, 83),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
