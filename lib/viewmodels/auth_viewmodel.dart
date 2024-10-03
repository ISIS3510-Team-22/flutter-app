import 'package:geolocator/geolocator.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../models/user_model.dart';
import 'package:flutter/material.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final LocationService _locationService = LocationService();
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  // Registrar usuario con ubicación
  Future<bool> registrarUsuarioConUbicacion(String name, String password) async {
    // Obtener la ubicación del usuario
    Position? ubicacion = await _locationService.obtenerUbicacion();
    if (ubicacion == null) {
      print("No se pudo obtener la ubicación.");
      return false;
    }

    // Registrar el usuario con email (name), password y ubicación (sin imagen)
    Usuario? usuario = await _authService.registrar(
      name, // 'name' es el email del usuario
      password,
      ubicacion.latitude,
      ubicacion.longitude,
    );

    if (usuario != null) {
      _usuarioActual = usuario;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> iniciarSesion(String name, String password) async {
    Usuario? usuario = await _authService.iniciarSesion(name, password);
    if (usuario != null) {
      _usuarioActual = usuario;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await _authService.cerrarSesion();
    _usuarioActual = null;
    notifyListeners();
  }

  // Comprobar si hay un usuario autenticado
  void verificarUsuarioActual() {
    _usuarioActual = _authService.obtenerUsuarioActual();
    notifyListeners();
  }
}