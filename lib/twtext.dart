import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TypewriterMarkdown extends StatefulWidget {
  final String text;
  final MarkdownStyleSheet? styleSheet;
  final Duration duration;

  const TypewriterMarkdown({
    Key? key,
    required this.text,
    this.styleSheet,
    this.duration = const Duration(milliseconds: 30),
  }) : super(key: key);

  @override
  _TypewriterMarkdownState createState() => _TypewriterMarkdownState();
}

class _TypewriterMarkdownState extends State<TypewriterMarkdown> {
  String _displayedText = "";
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypewriting();
  }

  void _startTypewriting() {
    _timer = Timer.periodic(widget.duration, (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: _displayedText,
      styleSheet: widget.styleSheet,
    );
  }
}
