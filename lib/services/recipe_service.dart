import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecipeService {
  static const String cacheKey = 'firebaseData';

  Future<List<Recipe>> getRecipes() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool hasInternet = connectivityResult != [ConnectivityResult.none];
    print(hasInternet);
    if (hasInternet) {
      CollectionReference recipeCollection =
          FirebaseFirestore.instance.collection('recipes');
      QuerySnapshot snapshot = await recipeCollection.get();
      var list = snapshot.docs.map((doc) {
        var data = Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        return data;
      }).toList();

      List<Map<String, dynamic>> mappedList = list.map((obj) {
        return obj.toMap();
      }).toList();
      _cacheData(mappedList);
      return list;
    } else {
      return await _getCachedData();
    }
  }

  Future<void> _cacheData(List<Object> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(cacheKey, jsonEncode(data));
  }

  Future<List<Recipe>> _getCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(cacheKey);
    if (jsonData != null) {
      Map<String, dynamic> data = jsonDecode(jsonData);
      Map<String, dynamic> recipesData = data['recipes'];
      List<Recipe> recipes = recipesData.entries.map((entry) {
        String recipeId = entry.key;
        Map<String, dynamic> recipeMap = entry.value;
        return Recipe.fromMap(recipeMap, recipeId);
      }).toList();

      return recipes;
    } else {
      // Return an empty list if there’s no cached data
      return [];
    }
  }
}
