import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyglide/models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/constants.dart';
import '../models/chat_model.dart';
import '../services/firestore_service.dart'; // Asegúrate de tener el servicio implementado
import 'chat_detail.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late double? latitudActual;
  late double? longitudActual;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    obtenerUbicacionActual();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void obtenerUbicacionActual() async {
    // Solicitar la ubicación actual usando el paquete geolocator
    LocationPermission permission = await Geolocator.checkPermission();

    // Si no hay permisos, solicitarlos
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    // Verificar si los servicios de ubicación están habilitados
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      // Los servicios de ubicación no están habilitados
      print('Los servicios de ubicación están deshabilitados.');
      return;
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Asignar la latitud y longitud obtenidas
    setState(() {
      latitudActual = position.latitude;
      longitudActual = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: const Text(
          'CHATS',
          style: headerTextStyle,
        ),
      ),
      body: latitudActual == null || longitudActual == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Usuario>>(
              future: _firestoreService.obtenerUsuariosCercanos(
                  latitudActual!, longitudActual!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text(
                    'No hay usuarios cercanos',
                    style: headerTextStyle,
                  ));
                }

                // Obtener la lista de usuarios
                final usuarios = snapshot.data!;

                // Filtrar el usuario actual de la lista de usuarios
                final filteredUsuarios = usuarios
                    .where((usuario) => usuario.id != currentUser!.uid)
                    .toList();

                // Ordenar los usuarios por distancia
                filteredUsuarios.sort((a, b) {
                  double distanciaA = _firestoreService.calcularDistancia(
                      latitudActual!, longitudActual!, a.latitud!, a.longitud!);
                  double distanciaB = _firestoreService.calcularDistancia(
                      latitudActual!, longitudActual!, b.latitud!, b.longitud!);
                  return distanciaA
                      .compareTo(distanciaB); // Ordenar de menor a mayor
                });

                // Construir la lista ordenada y filtrada
                return ListView.builder(
                  itemCount: filteredUsuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = filteredUsuarios[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF2C3E50), // Fondo oscuro similar
                          borderRadius:
                              BorderRadius.circular(20), // Bordes redondeados
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(usuario.profilePictureUrl ?? ''),
                          ),
                          title: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFF34495E), // Fondo del contenedor de texto
                              borderRadius: BorderRadius.circular(
                                  12), // Bordes redondeados
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nombre y distancia en la misma fila (Row)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      usuario.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_firestoreService.calcularDistancia(latitudActual!, longitudActual!, usuario.latitud!, usuario.longitud!).toStringAsFixed(2)} km', // Mostrar distancia calculada
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height:
                                        5), // Espacio entre nombre/distancia y el mensaje
                                const Text(
                                  'Toca para empezar a chatear',
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            _crearChat(usuario);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
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

  void _crearChat(Usuario usuario) async {
    // Obtener el usuario actual
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Generar un chatId único basado en los IDs de los usuarios
    String chatId = _generarChatId(currentUser.uid, usuario.id);

    // Intentar obtener el chat por su ID
    ChatModel? chatExistente = await _firestoreService.obtenerChatPorId(chatId);

    if (chatExistente == null) {
      // Si no existe el chat, creamos uno nuevo
      ChatModel nuevoChat = ChatModel(
        id: chatId, // Usar el chatId generado
        usuarioId:
            usuario.id, // ID del usuario con el que se está creando el chat
        username: usuario.name,
        lastMessage: '', // Iniciar con un mensaje vacío
        distance: _firestoreService.calcularDistancia(latitudActual!,
            longitudActual!, usuario.latitud!, usuario.longitud!),
        profilePictureUrl: usuario.profilePictureUrl ?? '',
      );

      // Guardar el nuevo chat en Firestore
      await _firestoreService.guardarChat(nuevoChat);

      // Navegar a la pantalla de detalles del chat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(chat: nuevoChat),
        ),
      );
    } else {
      // Si ya existe el chat, navega directamente a él
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(chat: chatExistente),
        ),
      );
    }
  }

// Función para generar un chatId único para ambos usuarios
  String _generarChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort(); // Ordenar los IDs alfabéticamente
    return 'chat_${ids[0]}_${ids[1]}'; // Concatenar los IDs para crear el chatId único
  }
}
