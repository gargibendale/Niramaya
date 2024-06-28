import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nirmaya/consts.dart';

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
  final List<String> _chatHistoryDisplay = [];
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
      _chatHistoryDisplay.add('$message');
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
        _chatHistoryDisplay.add('${response.text}');
      });
    } catch (e) {
      setState(() {
        _chatHistoryInternal.add({
          'role': 'model',
          'parts': [
            {'text': 'Error: $e'}
          ],
        });
        _chatHistoryDisplay.add('Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistoryDisplay.length,
              itemBuilder: (context, index) {
                final message = _chatHistoryDisplay[index];
                final isUserMessage =
                    (index % 2 == 0); // Assuming even index is user message
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
                            color: isUserMessage ? Colors.blue : Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: MarkdownBody(
                            data: message,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                  color: Colors.black), // Customize text style
                              strong: TextStyle(
                                  fontWeight: FontWeight
                                      .bold), // Customize bold text style
                              listBullet: TextStyle(
                                  color: Colors
                                      .black), // Customize bullet point color
                            ),
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
                    controller: _messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _handleSendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}