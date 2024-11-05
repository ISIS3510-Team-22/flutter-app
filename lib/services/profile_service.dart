import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/offline_profile_update_model.dart';
import '../services/firestore_service.dart';

class ProfileService {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late Box _offlineProfileUpdatesBox;

  ProfileService() {
    _initialize();
  }

  void _initialize() async {
    _offlineProfileUpdatesBox = await Hive.openBox('offline_profile_updates');
  }

  Future<void> saveProfileUpdate(String userId, {String? name, File? imageFile}) async {
    final hasConnection = await _isConnected();
    String? profilePictureUrl;

    if (imageFile != null && hasConnection) {
      // Intenta subir la imagen si hay conexión
      profilePictureUrl = await _uploadImageToFirebase(imageFile, userId);
    } else if (imageFile != null) {
      // Guarda la imagen localmente si no hay conexión
      profilePictureUrl = await _saveImageLocally(imageFile, userId);
    }

    if (hasConnection) {
      // Actualiza el perfil en Firestore si hay conexión
      await _firestoreService.updateUserProfile(userId, name: name, profilePictureUrl: profilePictureUrl);
      print('Perfil actualizado online');
    } else {
      // Guarda los cambios offline en Hive si no hay conexión
      final update = OfflineProfileUpdate(userId: userId, name: name, profilePictureUrl: profilePictureUrl);
      _offlineProfileUpdatesBox.put(userId, update);
      print('Perfil guardado offline');
    }
  }

  Future<void> syncOfflineProfileUpdates() async {
    final profileUpdates = _offlineProfileUpdatesBox.values.cast<OfflineProfileUpdate>();

    for (var update in profileUpdates) {
      try {
        String? profilePictureUrl;

        if (update.profilePictureUrl != null && File(update.profilePictureUrl!).existsSync()) {
          final imageFile = File(update.profilePictureUrl!);
          profilePictureUrl = await _uploadImageToFirebase(imageFile, update.userId);
        }

        await _firestoreService.updateUserProfile(update.userId, name: update.name, profilePictureUrl: profilePictureUrl);
        _offlineProfileUpdatesBox.delete(update.userId);
        print('Perfil sincronizado para ${update.userId}');
      } catch (e) {
        print('Error al sincronizar perfil offline: $e');
        return;
      }
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile, String userId) async {
    try {
      final ref = _firebaseStorage.ref().child('profile_pictures/$userId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error al subir imagen a Firebase Storage: $e');
      throw e;
    }
  }

  Future<String> _saveImageLocally(File imageFile, String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final localPath = '${directory.path}/profile_pictures_$userId.jpg';
    await imageFile.copy(localPath);
    return localPath;
  }

  Future<bool> _isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
