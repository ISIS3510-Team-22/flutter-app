import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  static final ConnectionService _instance = ConnectionService._internal();
  factory ConnectionService() => _instance;

  ConnectionService._internal();

  final StreamController<ConnectionStatus> _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  void startMonitoring() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        _connectionStatusController.add(ConnectionStatus.connected);
      } else {
        _connectionStatusController.add(ConnectionStatus.disconnected);
      }
    });
  }

  void dispose() {
    _connectionStatusController.close();
  }
}

enum ConnectionStatus { connected, disconnected }
