import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DetectionChatScreen extends StatefulWidget {
  const DetectionChatScreen({super.key});

  @override
  _DetectionChatScreenState createState() => _DetectionChatScreenState();
}

class _DetectionChatScreenState extends State<DetectionChatScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late final GenerativeModel _model;
  bool _loading = false;

  // Store API Key Securely in Production
  final String apiKey = "AIzaSyCJWMLHBWLqzoCvP9wiltjnsMeION8TyuY";

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      _sendImageForAnalysis(File(image.path));
    } catch (e) {
      _showErrorMessage('Error picking image. Please try again.');
    }
  }

  Future<void> _sendImageForAnalysis(File image) async {
    setState(() {
      _messages.add({'type': 'image', 'content': image});
      _loading = true;
    });

    try {
      final imageBytes = await image.readAsBytes();
      final response = await _model.generateContent([
        Content.text(
            "Analyze the given image. Provide a structured response with the following details:\n\n"
            "Short description:...\n"
            "Estimated Height: ...\n"
            "Estimated Width: ...\n"
            "Estimated Weight: ...\n"
            "Estimated Age: ...\n"
            "Nature/Category: ...\n"
            "Provide a two-time analysis report."),
        Content.data('image/jpeg', imageBytes),
      ]);

      _addMessage(response.text ?? "No response received.", isResponse: true);
    } catch (e) {
      _showErrorMessage('Error analyzing the image.');
    } finally {
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  void _addMessage(String content, {bool isResponse = false}) {
    setState(() {
      _messages
          .add({'type': isResponse ? 'response' : 'text', 'content': content});
    });
    _scrollToBottom();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 133, 133),
        duration: const Duration(seconds: 2),
      ),
    );
    _addMessage('❌ $message', isResponse: true);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<TextSpan> _processResponse(String text) {
    final List<TextSpan> textSpans = [];
    final RegExp boldRegex =
        RegExp(r'\*\*(.*?)\*\*'); // Matches text between **
    int currentIndex = 0;

    for (final match in boldRegex.allMatches(text)) {
      // Add the text before the match
      if (match.start > currentIndex) {
        textSpans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        );
      }

      // Add the bold text
      textSpans.add(
        TextSpan(
          text: match.group(1), // Text inside **
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      currentIndex = match.end;
    }

    // Add the remaining text after the last match
    if (currentIndex < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: const TextStyle(color: Colors.black, fontSize: 15),
        ),
      );
    }

    return textSpans;
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isResponse = message['type'] == 'response';
    return Align(
      alignment: isResponse ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isResponse ? Colors.brown[200] : Colors.orange[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: message['type'] == 'image'
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  message['content'],
                  width: 170,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              )
            : RichText(
                text: TextSpan(
                  children: _processResponse(message['content']),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 218, 202, 196), // Light skin-tone theme
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 248, 214, 163), // Warm accent color
        title: const Text(
          'AI Image Detection',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  _buildMessageBubble(_messages[index]),
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(color: Colors.black),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.orange[400], // Warm accent color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.image, color: Colors.black),
      ),
    );
  }
}
