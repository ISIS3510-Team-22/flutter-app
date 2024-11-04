import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyglide/models/message_chatAI_model.dart';

class FirestoreChatiaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarMensaje(String userId, Mensaje mensaje) async {
    try {
      await _firestore.collection('ai_chats').doc(userId).collection('messages').add(mensaje.toMap());
    } catch (e) {
      // ignore: avoid_print
      print('Error al guardar mensaje: $e');
    }
  }

  Stream<List<Mensaje>> obtenerMensajes(String userId) {
    return _firestore
        .collection('ai_chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: false) 
        .snapshots()
        .map((QuerySnapshot snapshot) {
          return snapshot.docs.map((doc) {
            return Mensaje.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }
  
  
}