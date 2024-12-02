import 'package:hive/hive.dart';

part 'offline_opinion_model.g.dart';


@HiveType(typeId: 1) // Asegúrate de que el typeId es único en toda la aplicación
class OfflineOpinion extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final double rating;

  @HiveField(3)
  final String comment;

  OfflineOpinion({
    required this.name,
    required this.id,
    required this.rating,
    required this.comment,
  });
}
