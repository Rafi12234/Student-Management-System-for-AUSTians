import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class AIAssistantPage extends StatefulWidget {
  @override
  _AIAssistantPageState createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  String _summary = "";
  String _questions = "";
  bool _isLoading = false;

  // Function to pick PDF and send it for text extraction
  Future<void> _pickAndUploadPDF() async {
    // Pick a PDF file from the device
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      String filename = result.files.single.name;

      // Send file for text extraction
      await _extractTextFromPDF(filename);
    }
  }

  // Function to send PDF file name for text extraction
  Future<void> _extractTextFromPDF(String filename) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Send the request to extract text
      final response = await http.post(
        Uri.parse('http://192.168.0.107:5000/extract_text'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"filename": filename}),
      );

      if (response.statusCode == 200) {
        // If text extraction is successful, extract AI data
        String extractedText = response.body;
        await _askAI(extractedText);
      } else {
        throw Exception('Failed to extract text');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Function to ask AI to summarize or generate questions
  Future<void> _askAI(String text) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.107:5000/ask_ai'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"text": text}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _summary = json.decode(response.body)["summary"];
          _questions = json.decode(response.body)["questions"];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Assistant"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickAndUploadPDF,
              child: Text("Upload PDF"),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator()),
            if (!_isLoading && _summary.isNotEmpty) ...[
              Text("Summary:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(_summary),
              SizedBox(height: 20),
              Text("Sample Questions:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(_questions),
            ],
          ],
        ),
      ),
    );
  }
}
