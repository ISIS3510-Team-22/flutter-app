import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/adapting_model.dart';

class AdaptingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all adapting models from the "adapting_tips" collection in Firestore.
  Future<List<AdaptingModel>> fetchAdaptingModels() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('adapting_tips').get();

      return snapshot.docs.map((doc) {
        return AdaptingModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
