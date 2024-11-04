import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/chat_model.dart';
import 'chat_detail.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de chats simulada
    List<ChatModel> chats = [
      ChatModel(
          username: 'Juan',
          distance: 1.2,
          lastMessage: 'Nos vemos mañana',
          profilePictureUrl:
              'https://randomuser.me/api/portraits/men/1.jpg'),
      ChatModel(
          username: 'Ana',
          distance: 0.5,
          lastMessage: '¿Cómo estás?',
          profilePictureUrl:
              'https://randomuser.me/api/portraits/women/2.jpg'),
      ChatModel(
          username: 'Carlos',
          distance: 2.5,
          lastMessage: 'Hola!',
          profilePictureUrl:
              'https://randomuser.me/api/portraits/men/3.jpg'),
      ChatModel(
          username: 'Marta',
          distance: 0.8,
          lastMessage: 'Gracias!',
          profilePictureUrl:
              'https://randomuser.me/api/portraits/women/4.jpg'),
    ];

    // Ordenar los chats por distancia (cercanía)
    chats.sort((a, b) => a.distance.compareTo(b.distance));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: const Text('CHATS',
        style: headerTextStyle,),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50), // Fondo oscuro similar
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(chat.profilePictureUrl),
                ),
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34495E), // Fondo del contenedor de texto
                    borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y distancia en la misma fila (Row)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${chat.distance} km',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5), // Espacio entre nombre/distancia y el mensaje
                      // Último mensaje
                      Text(
                        chat.lastMessage,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Navegar a la vista del chat específico
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(chat: chat),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
