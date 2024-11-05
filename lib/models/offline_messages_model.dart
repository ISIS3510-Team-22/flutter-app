import 'package:hive/hive.dart';

part 'offline_messages_model.g.dart';


@HiveType(typeId: 1) // Asegúrate de que el typeId es único en toda la aplicación
class OfflineMessage extends HiveObject {
  @HiveField(0)
  final String senderId;

  @HiveField(1)
  final String receiverId;

  @HiveField(2)
  final String texto;

  @HiveField(3)
  final int timestamp;

  OfflineMessage({
    required this.senderId,
    required this.receiverId,
    required this.texto,
    required this.timestamp,
  });
}
