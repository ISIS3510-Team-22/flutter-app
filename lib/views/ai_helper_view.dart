import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyglide/models/message_chatAI_model.dart';
import 'package:studyglide/services/firestore_chatIA_service.dart';
import 'package:studyglide/widgets/customAppBar.dart';
import '../constants/constants.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiHelperView extends StatefulWidget {
  const AiHelperView({super.key});

  @override
  _AiHelperViewState createState() => _AiHelperViewState();
}

class _AiHelperViewState extends State<AiHelperView> {
  final TextEditingController _controller = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirestoreChatiaService _fire = FirestoreChatiaService();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [];
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    _fire.obtenerMensajes(currentUser!.uid).listen((event) {
      setState(() {
        messages.clear();
        messages.addAll(event.map((msg) => msg.toMap()));
        // Verifica si es la primera carga y no hay mensajes previos
        if (firstLoad && messages.isEmpty) {
          final primerMensaje = Mensaje(
            senderId: "AI",
            receiverId: currentUser!.uid,
            message: "Hi, I am AI ChatBot. How can I help you?",
            timestamp: DateTime.now().millisecondsSinceEpoch,
          );
          messages.add(primerMensaje.toMap());
          _fire.guardarMensaje(currentUser!.uid, primerMensaje);
        }
        firstLoad = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final mensaje = Mensaje(
        senderId: currentUser!.uid,
        receiverId: "AI",
        message: _controller.text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      // Agrega el mensaje del usuario al chat inmediatamente
      setState(() {
        messages.add(mensaje.toMap());
        // Tiempo en el que el usuario envía una pregunta
      });
      DateTime questionSentTime = DateTime.now();
      _controller.clear();
      _scrollToBottom();

      try {
        // Prueba la solicitud usando GET en lugar de POST
        final response = await http.post(
          Uri.parse('https://chat.notadev.lat/chat'),
          headers: <String, String>{
            "x-api-key":
                "3b82626eab615f1343d276b6ea7a95b2112b7e5a3a8400fb7fcccb00fd2b8f2f56141594a2c5503fc8db715faac59c460ae08d4ab74ca888f1fc0a25e3524af5",
            "Content-Type": "application/json",
          },
          body: jsonEncode(<String, String>{
            "content": mensaje.message,
          }),
        );

        // Crear mensaje de respuesta de la IA
        final respuesta = Mensaje(
          senderId: "AI",
          receiverId: currentUser!.uid,
          message: response.body,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        // Tiempo en el que se recibe la respuesta
        DateTime responseReceivedTime = DateTime.now();

        // Tiempo de respuesta en milisegundos
        int responseTime =
            responseReceivedTime.difference(questionSentTime).inMilliseconds;

        logResponseTime(responseTime);

        // Agregar el mensaje de respuesta de la IA a la lista de mensajes
        setState(() {
          messages.add(respuesta.toMap());
        });

        // Guardar mensajes en Firestore
        await _fire.guardarMensaje(currentUser!.uid, mensaje);
        await _fire.guardarMensaje(currentUser!.uid, respuesta);
        _scrollToBottom();
      } catch (e) {
        // Manejo de errores en la solicitud HTTP
        print("Error al obtener la respuesta de la IA: $e");

        // En caso de error, agrega un mensaje de error
        setState(() {
          messages.add({
            'senderId': 'AI',
            'receiverId': currentUser!.uid,
            'message': 'No internet connection',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
        });
        _scrollToBottom();
      }
    }
  }

  void _clearMessages() {
    setState(() async {
      messages.clear();
      await _fire.borrarMensajes(currentUser!.uid);
    });
  }

  Future<void> logResponseTime(int responseTime) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "ia_chat_response_time",
      parameters: {
        "response_time_ms": responseTime, // Tiempo de respuesta en milisegundos
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Helper',
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clearMessages,
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return BubbleSpecialThree(
                  text: message['message'],
                  color: message['senderId'] == "AI"
                      ? const Color(0xFFE8E8EE)
                      : const Color(0xFF1B97F3),
                  tail: true,
                  textStyle: const TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  isSender: message['senderId'] != "AI",
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        showUnselectedLabels: true,
        unselectedItemColor: darkBlueColor,
        selectedItemColor: darkBlueColor,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/information');
              break;
            case 1:
              Navigator.pushNamed(context, '/chat');
              break;
            case 2:
              Navigator.pushNamed(context, '/news');
              break;
            case 3:
              Navigator.pushNamed(context, '/ai_helper');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Information',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI Helper',
          ),
        ],
      ),
    );
  }
}
