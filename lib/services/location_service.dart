import 'package:geolocator/geolocator.dart';

class LocationService {
  // Método para obtener la ubicación del usuario
  Future<Position?> obtenerUbicacion() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("El servicio de ubicación está deshabilitado");
      return null;
    }

    // Verifica los permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Los permisos de ubicación han sido denegados");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Los permisos de ubicación han sido denegados permanentemente");
      return null;
    }

    // Obtener la ubicación actual
    return await Geolocator.getCurrentPosition();
  }
}
