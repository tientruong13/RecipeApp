import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/model/recipe_api.dart';

class RecipeProvider with ChangeNotifier {
  List<RecipeModel> recipesList = [];
  late Box<String> bookmarkBox;

  RecipeProvider() {
    init();
  }

  Future<void> init() async {
    bookmarkBox = await Hive.openBox<String>('bookmarks');

    // Once box is open, update the recipesList's bookmark status.
    recipesList.forEach((recipe) {
      recipe.isBookmarked = bookmarkBox.containsKey(recipe.recipeId);
    });
    notifyListeners(); // Notify listeners once the data is ready.
  }

  List<RecipeModel> get getRecipesList {
    return recipesList;
  }

  Future<List<RecipeModel>> fetchAllRecipe() async {
    recipesList = await RecipeApi.getRecipe();
    // After fetching, ensure the bookmarks status is accurate
    recipesList.forEach((recipe) {
      recipe.isBookmarked = bookmarkBox.containsKey(recipe.recipeId);
    });
    return recipesList;
  }

  void toggleBookmark(RecipeModel recipe) {
    recipe.isBookmarked = !recipe.isBookmarked; // We can change it directly now
    if (recipe.isBookmarked) {
      bookmarkBox.put(recipe.recipeId, recipe.recipeId);
    } else {
      bookmarkBox.delete(recipe.recipeId);
    }
    notifyListeners();
  }

  List<RecipeModel> getBookmarkedRecipes() {
    return recipesList.where((recipe) => recipe.isBookmarked).toList();
  }

  Future<List<RecipeModel>> searchRecipe() async {
    recipesList = await RecipeApi.searchRecipe();
    return recipesList;
  }
}
