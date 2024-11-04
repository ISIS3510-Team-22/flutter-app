import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/services/firestore_service.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  // Obtiene el ID del usuario actual
  User? currentUser = FirebaseAuth.instance.currentUser;

  // Acción al enviar un mensaje
  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      final mensaje = Mensaje(
        senderId: currentUser!.uid,
        receiverId: widget.chat.usuarioId,
        texto: message,
        timestamp: DateTime.now().millisecondsSinceEpoch, // Guardar el timestamp en milisegundos
      );

      // Guardar el mensaje en Firestore
      await _firestoreService.guardarMensaje(widget.chat.id, mensaje);
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
            Text(widget.chat.username, style: headerTextStyle),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Mensaje>>(
              stream: _firestoreService.obtenerMensajes(widget.chat.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final mensajes = snapshot.data!;
                return ListView.builder(
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) {
                    final mensaje = mensajes[index];
                    print('Mensaje: ${mensaje.texto}');

                    bool esDelUsuarioActual = mensaje.senderId == currentUser!.uid;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: esDelUsuarioActual
                            ? Alignment.centerRight  // Mensaje del usuario actual a la derecha
                            : Alignment.centerLeft,  // Mensaje del otro usuario a la izquierda
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: esDelUsuarioActual
                                ? Colors.blueAccent.withOpacity(0.5)  // Color para mensajes del usuario actual
                                : Colors.red.withOpacity(0.5),       // Color para mensajes del receptor
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: esDelUsuarioActual ? const Radius.circular(12) : const Radius.circular(0),
                              bottomRight: esDelUsuarioActual ? const Radius.circular(0) : const Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            mensaje.texto,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
          ),
        ],
      ),
    );
  }
}
