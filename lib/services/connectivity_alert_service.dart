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
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          if (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) {
            _connectionStatusController.add(ConnectionStatus.connected);
          } else {
            _connectionStatusController.add(ConnectionStatus.disconnected);
          }
        } as void Function(List<ConnectivityResult> event)?);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}

enum ConnectionStatus { connected, disconnected }
