import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/provider/recipe_provider.dart';
import 'package:recipe_app/views/card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? query;
  double maxTime = 7200;
  int servings = 4;
  int fatKcalMax = 1000;

  List<RecipeModel> searchList = [];

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => query = value,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Slider(
                    value: maxTime,
                    onChanged: (value) {
                      setState(() => maxTime = value);
                    },
                    min: 0,
                    max: 14400, // 4 hours in seconds
                    divisions: 24,
                    label: "${maxTime / 3600} hours",
                  ),
                  Slider(
                    value: servings.toDouble(),
                    onChanged: (value) {
                      setState(() => servings = value.toInt());
                    },
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: "$servings servings",
                  ),
                  Slider(
                    value: fatKcalMax.toDouble(),
                    onChanged: (value) {
                      setState(() => fatKcalMax = value.toInt());
                    },
                    min: 100,
                    max: 2000,
                    divisions: 19,
                    label: "$fatKcalMax kcal",
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await recipeProvider.searchRecipe();
                    },
                    child: Text('Search'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, recipeProvider, child) {
                return FutureBuilder<List<RecipeModel>>(
                  future: recipeProvider.searchRecipe(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Display a loading indicator while waiting
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error: ${snapshot.error}')); // Display error
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                              'No recipes found.')); // Handle no data scenario
                    } else {
                      List<RecipeModel> searchResults = snapshot.data!;
                      return ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return RecipeCard(
                            title: searchResults[index].name.toString(),
                            cookTime: searchResults[index].totalTime.toString(),
                            rating: searchResults[index].rating.toString(),
                            thumbnailUrl:
                                searchResults[index].images.toString(),
                            recipe: searchResults[index],
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
