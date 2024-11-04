import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registrar usuario con name (email), password y ubicación
  Future<Usuario?> registrar(String name, String password, double latitud, double longitud) async {
    try {
      // Registro en Firebase Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: name, // Usamos el email como 'name'
          password: password);
      User? user = cred.user;

      // Creamos el modelo de Usuario con el email (name) y ubicación
      return Usuario.fromFirebaseUser(user!, latitud: latitud, longitud: longitud);
    } catch (e) {
      print("Error al registrar: $e");
      return null;
    }
  }

  // Iniciar sesión con name (email) y password
  Future<Usuario?> iniciarSesion(String name, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: name, // Usamos el email como 'name'
          password: password);
      User? user = cred.user;

      // Creamos el modelo de Usuario con el email (name)
      return user != null ? Usuario.fromFirebaseUser(user) : null;
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
    }
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  // Obtener usuario autenticado actual
  Usuario? obtenerUsuarioActual() {
    User? user = _auth.currentUser;
    return user != null ? Usuario.fromFirebaseUser(user) : null;
  }
}
