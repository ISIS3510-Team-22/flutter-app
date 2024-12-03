import 'package:cloud_firestore/cloud_firestore.dart';

class SearchedQueriesService {
  final CollectionReference searchedQueriesCollection =
      FirebaseFirestore.instance.collection('search_bar_queries');

  Future<void> addQuery(String docId, String query) async {
    final docRef = searchedQueriesCollection.doc(docId);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception("Document does not exist!");
      }
      String field = "queries";
      String currentValue = snapshot.get(field);
      if (query != "") {
        transaction.update(docRef, {field: "$currentValue,$query"});
      }
    });
  }
}
