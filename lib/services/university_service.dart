import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/university_model.dart';
import '../models/opinion_model.dart';

class UniversityService {
  final CollectionReference universityCollection =
      FirebaseFirestore.instance.collection('universities');

  Stream<List<University>> fetchUniversities() {
    // Fetch all universities
    return universityCollection.snapshots().asyncMap((snapshot) {
      // Map each document to a University object without awaiting
      return Future.wait(snapshot.docs.map((doc) {
        // Fetch the university data
        Map<String, dynamic> universityData =
            doc.data() as Map<String, dynamic>;

        return doc.reference
            .collection('opinions')
            .get()
            .then((opinionsSnapshot) {
          // Map each opinion document to an Opinion object
          // List<Opinion> opinions = opinionsSnapshot.docs.map((opinionDoc) {
          //   return Opinion.fromMap(opinionDoc.data(), opinionDoc.id);
          // }).toList();

          List<Opinion> opinions = [
            Opinion.fromMap({
              'name': 'Empty', // Nombre de la persona que dio la opinión
              'rating': 0.0, // Calificación dada a la universidad
              'comments': 'Empty.' // Comentarios de la opinión
            }, 'Empty')
          ];

          // Return the University object with the opinions included
          return University.fromMap(universityData, doc.id, opinions);
        });
      }).toList());
    });
  }
}
