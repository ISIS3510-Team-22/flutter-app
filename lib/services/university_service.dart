import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/university_model.dart';
import '../models/opinion_model.dart';

class UniversityService {
  final CollectionReference universityCollection =
      FirebaseFirestore.instance.collection('universities');

  Stream<List<University>> fetchUniversities() {
    return universityCollection.snapshots().asyncMap((snapshot) async {
      List<University> universities =
          await Future.wait(snapshot.docs.map((doc) async {
        Map<String, dynamic> universityData =
            doc.data() as Map<String, dynamic>;
        List<Opinion> opinions = await doc.reference
            .collection('opinions')
            .get()
            .then((opinionsSnapshot) {
          return opinionsSnapshot.docs.map((opinionDoc) {
            return Opinion.fromMap(opinionDoc.data(), opinionDoc.id);
          }).toList();
        });

        return University.fromMap(universityData, doc.id, opinions);
      }).toList());
      return universities;
    });
  }
}
