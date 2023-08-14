import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/provider/recipe_provider.dart';
import 'package:recipe_app/views/card.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<RecipeModel> bookmarkedRecipes =
        Provider.of<RecipeProvider>(context).getBookmarkedRecipes();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Favorites'),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: bookmarkedRecipes.isNotEmpty
          ? ListView.builder(
              itemCount: bookmarkedRecipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(
                  title: bookmarkedRecipes[index].name,
                  cookTime: bookmarkedRecipes[index].totalTime,
                  rating: bookmarkedRecipes[index].rating.toString(),
                  thumbnailUrl: bookmarkedRecipes[index].images ?? '',
                  recipe: bookmarkedRecipes[index],
                );
              },
            )
          : Center(
              child: Text('You haven\'t bookmarked any recipes yet.'),
            ),
    );
  }
}
