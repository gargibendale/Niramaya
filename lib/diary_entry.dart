import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nirmaya/consts.dart';

class DiaryEntryScreen extends StatefulWidget {
  @override
  _DiaryEntryScreenState createState() => _DiaryEntryScreenState();
}

class _DiaryEntryScreenState extends State<DiaryEntryScreen> {
  final TextEditingController _textController = TextEditingController();

  String _formattedDate = '';
  String _report = "";

  @override
  void initState() {
    super.initState();
    _updateDate();
  }

  Future<void> _saveEntry() async {
    final diaryEntry = _textController.text;
    const url =
        'https://diaryanalysis-gargi-bendales-projects.vercel.app/api/generate_report';
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${GOOGLE_API_KEY}',
          },
          body: jsonEncode({'diary_entry': diaryEntry}));

      if (response.statusCode == 200) {
        final report = jsonDecode(response.body)['report'];
        print("the report is ${report}");
        // Display the report to the user
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Mental Health Report'),
        //     content: Text(report),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.of(context).pop(),
        //         child: Text('OK'),
        //       ),
        //     ],
        //   ),
        // );
        setState(() {
          _report = report; // Update the report variable
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to generate report. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Exception: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _updateDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d, yyyy');
    setState(() {
      _formattedDate = formatter.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/dairy_bg.png"), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Today is $_formattedDate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _textController,
                  maxLines: 18,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Write your diary entry...',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Save diary entry logic here
                    _saveEntry();
                  },
                  child: Text('Generate Report'),
                ),
                SizedBox(height: 20),
                _report.isNotEmpty
                    ? RichText(
                        text: TextSpan(
                          children: _report.split('\n').map((line) {
                            if (line.startsWith('**')) {
                              return TextSpan(
                                text: line
                                    .replaceFirst('**', '')
                                    .replaceFirst('**', ''),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(
                                      255, 82, 33, 33), // Change the color here
                                ),
                              );
                            } else if (line.startsWith('*')) {
                              return TextSpan(
                                text:
                                    '\u2022 ${line.replaceFirst('', '').replaceAll('*', '')}\n',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 111, 111,
                                      111), // Change the color here
                                ),
                              );
                            } else {
                              return TextSpan(
                                text: line + '\n',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black, // Change the color here
                                ),
                              );
                            }
                          }).toList(),
                        ),
                      )
                    : Container(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _report));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Report copied to clipboard')),
                    );
                  },
                  child: Text('Copy Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}