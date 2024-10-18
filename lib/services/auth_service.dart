import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registrar usuario con name (email), password y ubicación
  Future<Usuario?> registrar(String name, String password, double latitud, double longitud) async {
    try {
      // Registro en Firebase Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: name, // Usamos el email como 'name'
          password: password);
      User? user = cred.user;

      // Creamos el modelo de Usuario con el email (name) y ubicación
      Usuario nuevoUsuario = Usuario.fromFirebaseUser(user!, latitud: latitud, longitud: longitud);

      // Guardar el usuario en Firestore
      await _firestore.collection('usuarios').doc(nuevoUsuario.id).set({
        'id': nuevoUsuario.id,
        'name': nuevoUsuario.name,
        'profilePictureUrl': nuevoUsuario.profilePictureUrl ?? '', // Si no hay imagen, deja el campo vacío
        'latitud': nuevoUsuario.latitud,
        'longitud': nuevoUsuario.longitud,
      });

      return nuevoUsuario;
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
