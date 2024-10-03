import 'package:flutter/material.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/models/chat_model.dart';

// Pantalla dedicada para cada chat
class ChatDetailScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> messages = [];

  // Acción al enviar un mensaje
  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        messages.add(message);
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.profilePictureUrl),
            ),
            const SizedBox(width: 10),
            Text(
              widget.chat.username,
              style: headerTextStyle,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // Espacio para mostrar los mensajes
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment
                        .centerRight, // Mensajes alineados a la izquierda
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        messages[index],
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: buttonTextStyle,
                    decoration: const InputDecoration(
                      hintStyle: buttonTextStyle,
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(),
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
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: 32),
          )
        ],
      ),
    );
  }
}
