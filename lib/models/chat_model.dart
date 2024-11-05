class ChatModel {
  final String id; // ID único del chat
  final String usuarioId; // ID del usuario en el chat
  late final String username;
  final String lastMessage;
  final double distance; // Distancia en km
  final String profilePictureUrl;

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
