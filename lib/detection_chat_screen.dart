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
            "Analyze the given image. Provide a structured response with:\n"
            "- **Short description:**\n"
            "- **Estimated Height:** (if applicable)\n"
            "- **Estimated Weight:** (if applicable)\n"
            "- **Estimated Age:** (if applicable)\n"
            "- **Nature or category:** (e.g., object, animal, person)."),
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
        backgroundColor: Colors.redAccent,
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

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isResponse = message['type'] == 'response';
    return Align(
      alignment: isResponse ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isResponse ? Colors.grey[800] : Colors.blueAccent,
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
                text: _parseBoldText(message['content']),
              ),
      ),
    );
  }

  TextSpan _parseBoldText(String text) {
    final List<TextSpan> spans = [];
    final RegExp exp = RegExp(r"\*\*(.*?)\*\*"); // Detects **bold text**
    int lastMatchEnd = 0;

    for (final Match match in exp.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ));
      }

      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 15,
        ),
      ));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ));
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'AI Image Detection',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.image, color: Colors.white),
      ),
    );
  }
}
