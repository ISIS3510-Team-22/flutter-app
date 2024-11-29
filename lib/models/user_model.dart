import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usuario {
  final String id;
  final String name;
  final String? profilePictureUrl; // URL de la imagen de perfil (puede ser opcional)
  final double? latitud; // Latitud del usuario
  final double? longitud; // Longitud del usuario

  Usuario({
    required this.id,
    required this.name,
    this.profilePictureUrl,
    this.latitud,
    this.longitud,
  });

  factory Usuario.fromFirebaseUser(User user, {double? latitud, double? longitud}) {
    return Usuario(
      id: user.uid,
      name: user.email!,
      profilePictureUrl: "",
      latitud: latitud,
      longitud: longitud,
    );
  }

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: doc.id,
      name: data['name'] ?? 'Sin nombre',
      profilePictureUrl: data['profilePictureUrl'],
      latitud: (data['latitud'] ?? 0.0).toDouble(),
      longitud: (data['longitud'] ?? 0.0).toDouble(),
    );
  }
}

