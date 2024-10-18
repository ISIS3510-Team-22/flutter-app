
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyglide/models/user_model.dart';

import '../../../global/common/toast.dart';


class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, double latitud, double longitud) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = credential.user;

      if (user != null) {
        // Crear el modelo de usuario con la ubicación
        Usuario nuevoUsuario = Usuario(
          id: user.uid,
          name: user.email!,
          latitud: latitud,
          longitud: longitud,
          profilePictureUrl: null, // Dejar nulo si no tienes imagen aún
        );

        // Guardar el usuario en Firestore
        await _firestore.collection('usuarios').doc(user.uid).set({
          'id': nuevoUsuario.id,
          'name': nuevoUsuario.name,
          'latitud': nuevoUsuario.latitud,
          'longitud': nuevoUsuario.longitud,
          'profilePictureUrl': nuevoUsuario.profilePictureUrl ?? '', // Si no hay imagen, dejar vacío
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

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
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
}

