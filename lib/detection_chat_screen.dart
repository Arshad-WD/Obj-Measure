import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetectionChatScreen extends StatefulWidget {
  const DetectionChatScreen({super.key});

  @override
  _DetectionChatScreenState createState() => _DetectionChatScreenState();
}

class _DetectionChatScreenState extends State<DetectionChatScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  GenerativeModel? _model; // ✅ Nullable model

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  /// ✅ Initialize the GenerativeModel safely
  Future<void> _initializeModel() async {
    String? apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint("❌ API key is missing. Check .env file.");
      return;
    }
    setState(() {
      _model = GenerativeModel(
        model: 'gemini-2-vision-latest',
        apiKey: apiKey,
      );
    });
  }

  /// ✅ Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      _sendImageMessage(imageFile);
    }
  }

  /// ✅ Process image and send to Gemini API
  Future<void> _sendImageMessage(File image) async {
    setState(() {
      _messages.add({'type': 'image', 'content': image});
    });

    // ✅ Ensure the model is initialized before use
    if (_model == null) {
      setState(() {
        _messages.add({
          'type': 'response',
          'content': '❌ Model not initialized. Please restart the app.'
        });
      });
      return;
    }

    try {
      final imageBytes = await image.readAsBytes();
      final response = await _model!.generateContent([
        Content.text("Analyze this image and describe its contents."),
        Content.data('image/jpeg', base64Encode(imageBytes) as Uint8List),
      ]);

      setState(() {
        _messages.add({
          'type': 'response',
          'content': response.text ?? "ℹ️ No response received."
        });
      });
    } catch (e) {
      setState(() {
        _messages.add(
            {'type': 'response', 'content': '❌ Error analyzing the image.'});
      });
      debugPrint("❌ Error: $e");
    }

    _scrollToBottom();
  }

  /// ✅ Scrolls to the latest message
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  /// ✅ Build chat message bubbles
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    if (message['type'] == 'image') {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(
              message['content'],
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else if (message['type'] == 'response') {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message['content'],
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
        title: const Text('Image Detection Chat',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FloatingActionButton(
              onPressed: _pickImage,
              backgroundColor: const Color.fromARGB(255, 0, 89, 255),
              child: const Icon(Icons.image),
            ),
          ),
        ],
      ),
    );
  }
}
