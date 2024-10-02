import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  // Fetch recipes and notify the view
  void fetchRecipes() {
    _recipeService.getRecipes().listen((recipeList) {
      _recipes = recipeList;
      notifyListeners(); // Notifies the View to rebuild with new data
    });
  }
}
