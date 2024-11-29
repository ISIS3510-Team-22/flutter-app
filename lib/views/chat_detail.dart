

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/models/offline_messages_model.dart';
import 'package:studyglide/services/firestore_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  final Connectivity _connectivity = Connectivity();
  late Box _offlineMessagesBox;

  // Obtiene el ID del usuario actual
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _offlineMessagesBox = Hive.box('offline_messages');
    _sendOfflineMessages();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
  // Verifica si al menos uno de los resultados no es "none"
  if (results.any((result) => result != ConnectivityResult.none)) {
    _sendOfflineMessages(); // Intenta enviar mensajes guardados cuando vuelve la conexión
  }
});
  }

  // Acción al enviar un mensaje
  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      final mensaje = Mensaje(
        senderId: currentUser!.uid,
        receiverId: widget.chat.usuarioId,
        texto: message,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      // Verificar conexión a internet
      if (await isConnected()) {
        await _firestoreService.guardarMensaje(widget.chat.id, mensaje);
      } else {
        _saveMessageOffline(mensaje);
      }
      _messageController.clear();
    }
  }
  Future<bool> isConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    print('Error al verificar conexión: $e');
    return false;
  }
}


  // Guardar mensaje offline en Hive
  void _saveMessageOffline(Mensaje mensaje) {
    final offlineMessage = OfflineMessage(
      senderId: mensaje.senderId,
      receiverId: mensaje.receiverId,
      texto: mensaje.texto,
      timestamp: mensaje.timestamp,
    );

    // Convierte la lista al tipo correcto
    final messages = List<OfflineMessage>.from(_offlineMessagesBox
        .get(widget.chat.id, defaultValue: <OfflineMessage>[]) as List);
    messages.add(offlineMessage);
    _offlineMessagesBox.put(widget.chat.id, messages);
    print('Mensaje guardado offline: ${offlineMessage.texto}');
  }

// Enviar mensajes offline cuando hay conexión
Future<void> _sendOfflineMessages() async {
  if (await isConnected()) {  // Verifica la conexión a internet
    final messages = List<OfflineMessage>.from(_offlineMessagesBox.get(widget.chat.id, defaultValue: <OfflineMessage>[]) as List);
    if (messages.isNotEmpty) {
      for (var offlineMessage in messages) {
        final mensaje = Mensaje(
          senderId: offlineMessage.senderId,
          receiverId: offlineMessage.receiverId,
          texto: offlineMessage.texto,
          timestamp: offlineMessage.timestamp,
        );

          try {
            await _firestoreService.guardarMensaje(widget.chat.id, mensaje);
          } catch (e) {
            print('Error al enviar mensaje offline: $e');
            return; // Sal del bucle si ocurre un error
          }
        }
        _offlineMessagesBox
            .delete(widget.chat.id); // Limpia los mensajes enviados
        print('Mensajes offline enviados.');
      }
    } else {
      print("No hay conexión. Los mensajes permanecerán en espera.");
    }
  }

  void listarMensajesOffline() {
    final messages = _offlineMessagesBox.get(widget.chat.id,
        defaultValue: <OfflineMessage>[]) as List<OfflineMessage>;
    messages.forEach((msg) {
      print("Mensaje offline guardado: ${msg.texto}");
    });
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
            Flexible(
                child: Text(widget.chat.username,
                    style: headerTextStyle, overflow: TextOverflow.ellipsis)),
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
                print(widget.chat.username);
                final mensajes = snapshot.data!;
                return ListView.builder(
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) {
                    final mensaje = mensajes[index];
                    print('Mensaje: ${mensaje.texto}');

                    bool esDelUsuarioActual =
                        mensaje.senderId == currentUser!.uid;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: esDelUsuarioActual
                            ? Alignment
                                .centerRight // Mensaje del usuario actual a la derecha
                            : Alignment
                                .centerLeft, // Mensaje del otro usuario a la izquierda
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: esDelUsuarioActual
                                ? Colors.blueAccent.withOpacity(
                                    0.5) // Color para mensajes del usuario actual
                                : Colors.red.withOpacity(
                                    0.5), // Color para mensajes del receptor
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: esDelUsuarioActual
                                  ? const Radius.circular(12)
                                  : const Radius.circular(0),
                              bottomRight: esDelUsuarioActual
                                  ? const Radius.circular(0)
                                  : const Radius.circular(12),
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
                  onPressed: () {
                    _sendMessage();
                    listarMensajesOffline();
                  },
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
