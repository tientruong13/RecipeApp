import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/provider/recipe_provider.dart';
import 'package:recipe_app/recipe_screen.dart';
import 'package:recipe_app/search_screen.dart';
import 'package:recipe_app/views/card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          icon: Icon(Icons.search),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Food Recipe')
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen()),
              );
            },
            icon: Icon(Icons.bookmark, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<RecipeModel>>(
              future: recipeProvider.fetchAllRecipe(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(
                        title: snapshot.data![index].name.toString(),
                        cookTime: snapshot.data![index].totalTime.toString(),
                        rating: snapshot.data![index].rating.toString(),
                        thumbnailUrl: snapshot.data![index].images.toString(),
                        recipe: snapshot.data![index],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
