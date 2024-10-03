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
      profilePictureUrl: null,
      latitud: latitud,
      longitud: longitud,
    );
  }
}

