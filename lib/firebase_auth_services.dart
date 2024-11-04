import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyglide/models/user_model.dart';
import '../../../global/common/toast.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password,
      double latitud, double longitud, String name) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = credential.user;

      if (user != null) {
        // Generar la URL de la imagen de perfil usando RoboHash
        String profilePictureUrl = 'https://robohash.org/${user.uid}?set=set5';

        // Crear el modelo de usuario con la ubicación y la imagen de perfil
        Usuario nuevoUsuario = Usuario(
          id: user.uid,
          name: name,
          latitud: latitud,
          longitud: longitud,
          profilePictureUrl: profilePictureUrl,
        );

        // Guardar el usuario en Firestore
        await _firestore.collection('usuarios').doc(user.uid).set({
          'id': nuevoUsuario.id,
          'name': nuevoUsuario.name,
          'latitud': nuevoUsuario.latitud,
          'longitud': nuevoUsuario.longitud,
          'profilePictureUrl': nuevoUsuario.profilePictureUrl,
        });

        showToast(message: 'User successfully registered.');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else if (e.code == 'invalid-credential') {
        showToast(message: 'The email or password is incorrect.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      showToast(message: 'Successfully logged out.');
    } catch (e) {
      showToast(message: 'Error logging out: $e');
    }
  }
}
