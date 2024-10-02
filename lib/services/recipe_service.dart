import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  Stream<List<Recipe>> getRecipes() {
    return recipeCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
