import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class AiHelperView extends StatefulWidget {
  const AiHelperView({super.key});

  @override
  _AiHelperViewState createState() => _AiHelperViewState();
}

class _AiHelperViewState extends State<AiHelperView> {
  final List<Map<String, dynamic>> messages = [
    {"text": "Hello, I am AI ChatBot. How can I help you?", "isUser": false}
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({"text": _controller.text, "isUser": true});
        messages.add(
            {"text": "Bot response", "isUser": false}); // Respuesta de la IA
      });
      _controller.clear();
    }
  }

  void _clearMessages() {
    setState(() {
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: const Center(
          child: Text(
            "AI HELPER",
            style: headerTextStyle,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clearMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return BubbleSpecialThree(
                  text: message['text'],
                  color: message['isUser']
                      ? const Color(0xFF1B97F3)
                      : const Color(0xFFE8E8EE),
                  tail: false,
                  textStyle: const TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  isSender: message['isUser'],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: simpleText,
                    decoration: InputDecoration(
                      hintText: "Write a message...",
                      hintStyle: simpleText,
                      labelStyle: simpleText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
