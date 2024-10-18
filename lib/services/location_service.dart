import 'package:geolocator/geolocator.dart';

class LocationService {
  // Método para obtener la latitud y longitud del dispositivo
  Future<Position?> obtenerUbicacionActual() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si los servicios no están habilitados, retorna null
      print('Los servicios de ubicación están deshabilitados.');
      return null;
    }

    // Solicitar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Si el permiso es denegado, retorna null
        print('Los permisos de ubicación fueron denegados.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos son denegados permanentemente, no se puede acceder a la ubicación
      print('Los permisos de ubicación están denegados permanentemente.');
      return null;
    }

    // Finalmente, obtener la ubicación actual
    return await Geolocator.getCurrentPosition();
  }
}
