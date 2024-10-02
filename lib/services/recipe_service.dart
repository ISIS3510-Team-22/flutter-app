import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  // Add a new recipe
  Future<void> addRecipe(Recipe recipe) async {
    await recipeCollection.add(recipe.toMap());
  }

  // Update an existing recipe
  Future<void> updateRecipe(Recipe recipe) async {
    await recipeCollection.doc(recipe.id).update(recipe.toMap());
  }

  // Delete a recipe
  Future<void> deleteRecipe(String id) async {
    await recipeCollection.doc(id).delete();
  }

  // Get a single recipe by ID
  Future<Recipe?> getRecipe(String id) async {
    DocumentSnapshot doc = await recipeCollection.doc(id).get();
    if (doc.exists) {
      return Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Get all recipes
  Stream<List<Recipe>> getRecipes() {
    return recipeCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
