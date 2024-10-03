import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user_model.dart';

class ChatViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener la ubicación actual del usuario
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Los servicios de ubicación están deshabilitados.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permisos de ubicación denegados.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permisos de ubicación denegados permanentemente.");
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Calcular la distancia entre dos puntos geográficos
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // En km
  }

  // Obtener el usuario actual autenticado
  Usuario getCurrentUser() {
    final User user = _auth.currentUser!;
    return Usuario.fromFirebaseUser(user);
  }

  // Obtener usuarios cercanos desde Firebase Firestore
  Future<List<Usuario>> getNearbyUsers() async {
    // Obtener la ubicación actual del usuario
    Position position = await getCurrentLocation();
    double currentUserLatitude = position.latitude;
    double currentUserLongitude = position.longitude;

    // Obtener la lista de usuarios desde Firebase Firestore
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();

    List<Usuario> users = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Usuario(
        id: doc.id,
        name: data['name'] ?? 'Usuario desconocido',
        profilePictureUrl: data['profilePictureUrl'],
        latitud: data['location']['latitude'],
        longitud: data['location']['longitude'],
      );
    }).toList();

    // Ordenar usuarios por cercanía
    users.sort((a, b) {
      double distanceA = calculateDistance(
        currentUserLatitude, currentUserLongitude, a.latitud!, a.longitud!,
      );
      double distanceB = calculateDistance(
        currentUserLatitude, currentUserLongitude, b.latitud!, b.longitud!,
      );
      return distanceA.compareTo(distanceB);
    });

    return users;
  }
}
