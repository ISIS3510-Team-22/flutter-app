import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mental_health_model.dart';

class MentalHealthService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('mental_health');

  // Fetch all mental health records
  Future<List<MentalHealthModel>> fetchMentalHealthRecords() async {
    QuerySnapshot snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      return MentalHealthModel.fromMap(
          doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
