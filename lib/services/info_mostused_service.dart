import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/info_mostused_model.dart';

class InfoMostUsedService {
  final CollectionReference infoMostUsedCollection =
      FirebaseFirestore.instance.collection('info_most_used');

  Stream<List<InfoMostUsed>> getInfoMostUsed() {
    return infoMostUsedCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return InfoMostUsed.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> incrementField(String docId, String field) async {
    final docRef = infoMostUsedCollection.doc(docId);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception("Document does not exist!");
      }
      int currentValue = snapshot.get(field) as int;
      transaction.update(docRef, {field: currentValue + 1});
    });
  }
}
