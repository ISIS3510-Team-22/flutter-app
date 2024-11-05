import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../models/offline_messages_model.dart';
import '../models/message_model.dart';
import '../services/firestore_service.dart';
import '../services/profile_service.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final FirestoreService _firestoreService = FirestoreService();
  final ProfileService _profileService = ProfileService();
  late Box _offlineMessagesBox;
  // ignore: unused_field
  late Box _offlineProfileUpdatesBox;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityService() {
    _initialize();
  }

  void _initialize() async {
    _offlineProfileUpdatesBox = await Hive.openBox('offline_profile_updates');
    _offlineMessagesBox = await Hive.openBox('offline_messages'); 
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _sendOfflineMessages(); // Intenta enviar mensajes al recuperar conexión
        _profileService.syncOfflineProfileUpdates();
      }
    }) as StreamSubscription<ConnectivityResult>?;
  }

  Future<void> _sendOfflineMessages() async {

    for (var chatId in _offlineMessagesBox.keys) {
      final messages = List<OfflineMessage>.from(_offlineMessagesBox.get(chatId, defaultValue: <OfflineMessage>[]) as List);
      if (messages.isNotEmpty) {
        for (var offlineMessage in messages) {
          final mensaje = Mensaje(
            senderId: offlineMessage.senderId,
            receiverId: offlineMessage.receiverId,
            texto: offlineMessage.texto,
            timestamp: offlineMessage.timestamp,
          );

          try {
            await _firestoreService.guardarMensaje(chatId, mensaje);
          } catch (e) {
            print('Error al enviar mensaje offline: $e');
            return; 
          }
        }
        _offlineMessagesBox.delete(chatId); // Limpia los mensajes enviados para este chat
        print('Mensajes offline enviados para chat $chatId.');
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
