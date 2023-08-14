import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app/model/recipe.dart';

// const unirest = require("unirest");

// const req = unirest("GET", "https://yummly2.p.rapidapi.com/feeds/list");

// req.query({
// 	"limit": "24",
// 	"start": "0"
// });

// req.headers({
// 	"X-RapidAPI-Key": "8e2391b4fcmshceb97f33cd70ec6p13533bjsnf5ae4582b959",
// 	"X-RapidAPI-Host": "yummly2.p.rapidapi.com",
// 	"useQueryString": true
// });

class RecipeApi {
  static Future<List<RecipeModel>> getRecipe() async {
    try {
      var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list',
          {"limit": "24", "start": "0"});

      final response = await http.get(uri, headers: {
        "X-RapidAPI-Key": "8e2391b4fcmshceb97f33cd70ec6p13533bjsnf5ae4582b959",
        "X-RapidAPI-Host": "yummly2.p.rapidapi.com",
        "useQueryString": 'true'
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> mapData = json.decode(response.body);
        final List<dynamic> feedData = mapData['feed'];

        return feedData
            .map((e) {
              var details = e['content']['details'];
              if (details != null) {
                details['ingredientLines'] = e['content']['ingredientLines'];
                return RecipeModel.fromJson(details);
              } else {
                return null;
              }
            })
            .where((recipe) => recipe != null)
            .cast<RecipeModel>() // casting nullable to non-nullable
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<RecipeModel>> searchRecipe({
    String? query,
    int start = 0,
    int maxResult = 18,
    int? maxTotalTimeInSeconds,
    String? allowedAttribute,
    int? FAT_KCALMax,
  }) async {
    try {
      final parameters = {
        "start": start.toString(),
        "maxResult": maxResult.toString(),
        "maxTotalTimeInSeconds": maxTotalTimeInSeconds.toString(),
        if (query != null) "q": query,
        if (allowedAttribute != null) "allowedAttribute": allowedAttribute,
        if (FAT_KCALMax != null) "FAT_KCALMax": FAT_KCALMax.toString(),
      };

      var uri =
          Uri.https('yummly2.p.rapidapi.com', '/feeds/search', parameters);

      final response = await http.get(uri, headers: {
        "X-RapidAPI-Key": "8e2391b4fcmshceb97f33cd70ec6p13533bjsnf5ae4582b959",
        "X-RapidAPI-Host": "yummly2.p.rapidapi.com",
        "useQueryString": 'true'
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> mapData = json.decode(response.body);
        final List<dynamic> feedData = mapData['feed'];

        return feedData
            .map((e) {
              var details = e['content']['details'];
              if (details != null) {
                details['ingredientLines'] = e['content']['ingredientLines'];
                return RecipeModel.fromJson(details);
              } else {
                return null;
              }
            })
            .where((recipe) => recipe != null)
            .cast<RecipeModel>() // casting nullable to non-nullable
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw error.toString();
    }
  }
}

// const options = {
//   method: 'GET',
//   url: 'https://yummly2.p.rapidapi.com/feeds/search',
//   params: {
//     start: '0',
//     maxResult: '18',
//     maxTotalTimeInSeconds: '7200',
//     q: 'chicken soup',
//     allowedAttribute: 'diet-lacto-vegetarian,diet-low-fodmap',
//     FAT_KCALMax: '1000'
//   },
//   headers: {
//     'X-RapidAPI-Key': '8e2391b4fcmshceb97f33cd70ec6p13533bjsnf5ae4582b959',
//     'X-RapidAPI-Host': 'yummly2.p.rapidapi.com'
//   }
// };
