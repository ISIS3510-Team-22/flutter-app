import 'package:hive/hive.dart';

part 'offline_profile_update_model.g.dart';

@HiveType(typeId: 2) // Asegúrate de que este `typeId` sea único
class OfflineProfileUpdate extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? profilePictureUrl;

  OfflineProfileUpdate({
    required this.userId,
    this.name,
    this.profilePictureUrl,
  });
}
