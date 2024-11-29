import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
   String id; // ID único del chat
   String usuarioId; // ID del usuario en el chat
   String username;
   String lastMessage;
   double distance; // Distancia en km
   String profilePictureUrl;

  ChatModel({
    required this.id,
    required this.usuarioId,
    required this.username,
    required this.lastMessage,
    required this.distance,
    required this.profilePictureUrl,
  });

  // Convertir de Map (Firestore) a ChatModel
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      usuarioId: map['usuarioId'] as String,
      username: map['username'] as String,
      lastMessage: map['lastMessage'] as String,
      distance: map['distance'] as double,
      profilePictureUrl: map['profilePictureUrl'] as String,
    );
  }

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Convierte los datos a un Map
    return ChatModel(
      id: doc.id, // Firestore usa `id` como identificador del documento
      usuarioId: data['usuarioId'],
      username: data['username'] ?? 'Usuario desconocido',
      lastMessage: data['lastMessage'] ?? '',
      distance: (data['distance'] ?? 0.0).toDouble(),
      profilePictureUrl: data['profilePictureUrl'] ?? '',
    );
  }

  // Convertir ChatModel a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'username': username,
      'lastMessage': lastMessage,
      'distance': distance,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
