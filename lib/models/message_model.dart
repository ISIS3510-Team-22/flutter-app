class Mensaje {
  final String senderId;
  final String receiverId;
  final String texto;
  final int timestamp;  // Usar int para manejar los milisegundos desde la época

  Mensaje({
    required this.senderId,
    required this.receiverId,
    required this.texto,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'texto': texto,
      'timestamp': timestamp, // Guardar como milisegundos en Firestore
    };
  }

  factory Mensaje.fromMap(Map<String, dynamic> map) {
    return Mensaje(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      texto: map['texto'],
      timestamp: map['timestamp'],  // Ya es un int, lo manejas como tal
    );
  }

  // Si en algún momento necesitas convertir el timestamp a DateTime:
  DateTime getTimestampAsDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}