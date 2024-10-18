import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyglide/models/chat_model.dart';
import 'package:studyglide/models/message_model.dart';
import 'package:studyglide/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371; // Radio de la Tierra en kilómetros
  var dLat = _gradosARadianes(lat2 - lat1);
  var dLon = _gradosARadianes(lon2 - lon1);
  var a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_gradosARadianes(lat1)) * cos(_gradosARadianes(lat2)) *
      sin(dLon / 2) * sin(dLon / 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _gradosARadianes(double grados) {
  return grados * pi / 180;
}

  Future<List<Usuario>> obtenerUsuariosCercanos(double latitudActual, double longitudActual) async {
  try {
    QuerySnapshot snapshot = await _firestore.collection('usuarios').get();
    
    List<Usuario> usuarios = snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      print('Usuario encontrado: ${data['name']} con latitud: ${data['latitud']}, longitud: ${data['longitud']}');
      
      return Usuario(
        id: data['id'],
        name: data['name'],
        profilePictureUrl: data['profilePictureUrl'],
        latitud: data['latitud'],
        longitud: data['longitud'],
      );
    }).toList();

    // Si no hay usuarios
    if (usuarios.isEmpty) {
      print('No se encontraron usuarios en Firestore.');
    }

    // Filtrar usuarios cercanos por distancia
    usuarios.sort((a, b) {
      double distanciaA = calcularDistancia(latitudActual, longitudActual, a.latitud!, a.longitud!);
      double distanciaB = calcularDistancia(latitudActual, longitudActual, b.latitud!, b.longitud!);
      return distanciaA.compareTo(distanciaB); // Ordenar de menor a mayor distancia
    });

    return usuarios;
  } catch (e) {
    print('Error al obtener usuarios: $e');
    return [];
  }
}

  Future<void> guardarUsuario(Usuario usuario) async {
    try {
      await _firestore.collection('usuarios').doc(usuario.id).set({
        'id': usuario.id,
        'name': usuario.name,
        'profilePictureUrl': usuario.profilePictureUrl ?? '', // Si no tiene imagen, deja el campo vacío
        'latitud': usuario.latitud,
        'longitud': usuario.longitud,
      });
    } catch (e) {
      print('Error al guardar usuario en Firestore: $e');
    }
  }

  Future<void> guardarMensaje(String chatId, Mensaje mensaje) async {
    try {
      await _firestore.collection('chats').doc(chatId).collection('mensajes').add(mensaje.toMap());
    } catch (e) {
      print('Error al guardar mensaje: $e');
    }
  }

  // Obtener mensajes de una conversación
  Stream<List<Mensaje>> obtenerMensajes(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('mensajes')
        .orderBy('timestamp', descending: false) 
        .snapshots()
        .map((QuerySnapshot snapshot) {
          return snapshot.docs.map((doc) {
            return Mensaje.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }

  Future<String> obtenerChatId(String usuario1Id, String usuario2Id) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .where('usuarios', arrayContainsAny: [usuario1Id, usuario2Id])
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id; // Si existe un chat, devolvemos su ID
      } else {
        return ''; // Si no existe, devolvemos un string vacío
      }
    } catch (e) {
      print('Error al obtener chat: $e');
      return '';
    }
  }

  // Guardar un nuevo chat en Firestore
  Future<void> guardarChat(ChatModel chat) async {
    try {
      await _firestore.collection('chats').doc(chat.id).set(chat.toMap());
    } catch (e) {
      print('Error al guardar chat: $e');
    }
  }

  Future<ChatModel?> obtenerChatPorId(String chatId) async {
  try {
    DocumentSnapshot doc = await _firestore.collection('chats').doc(chatId).get();

    // Verificar si el documento existe
    if (doc.exists) {
      // Obtener los datos del documento
      var data = doc.data();
      
      // Asegurarse de que los datos no sean null y sean del tipo Map
      if (data != null && data is Map<String, dynamic>) {
        return ChatModel.fromMap(data);
      } else {
        print('Error: Los datos del chat no son válidos o están mal formados.');
        return null;
      }
    } else {
      print('Error: Chat no encontrado.');
      return null;
    }
  } catch (e) {
    print('Error al obtener chat por ID: $e');
    return null;
  }
}


  

}


