import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await _recipeService.getRecipes();
    } catch (e) {
      // Handle error (e.g., show a toast or a snackbar)
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
