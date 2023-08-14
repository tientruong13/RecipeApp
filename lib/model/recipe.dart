class RecipeModel {
  final String name;
  final String? images; // images can be null, hence making it nullable
  final double rating;
  final String totalTime;
  final int numberOfServings;
  final String recipeId;
  final String directionsUrl;
  final List<Ingredient> ingredientLines;
  final List<String> directions;
  bool isBookmarked;

  RecipeModel({
    required this.name,
    required this.isBookmarked,
    this.images, // making it optional since it can be null
    required this.rating,
    required this.totalTime,
    required this.numberOfServings,
    required this.recipeId,
    required this.directionsUrl,
    required this.ingredientLines,
    required this.directions,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      isBookmarked: false,
      name: json['name'] ?? '',
      images: ((json['images'] as List?)?.isNotEmpty ?? false)
          ? json['images'][0]['hostedLargeUrl'] as String
          : null,
      rating: json['rating'] != null
          ? json['rating'].toDouble()
          : 0.0, // converting to double and defaulting to 0
      totalTime: json['totalTime'] ?? '',
      numberOfServings: json['servings'] != null
          ? (json['servings'] is int
              ? json['servings']
              : int.tryParse(json['servings'].toString()) ?? 0)
          : 0, // converting to int and defaulting to 0
      recipeId: json['recipeId'] ?? '',
      directionsUrl: json['directionsUrl'] ?? '',
      ingredientLines: (json['ingredientLines'] as List?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      directions:
          (json['directions'] as List?)?.map((e) => e.toString()).toList() ??
              [],
    );
  }
}

class Ingredient {
  final String category;
  final String unit;
  final String ingredientId;
  final String categoryId;
  final String ingredient;
  final String id;
  final String remainder;
  final int quantity;
  final String wholeLine;

  Ingredient({
    required this.category,
    required this.unit,
    required this.ingredientId,
    required this.categoryId,
    required this.ingredient,
    required this.id,
    required this.remainder,
    required this.quantity,
    required this.wholeLine,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      category: json['category'] ?? '',
      unit: json['amount']['unit'] ?? '',
      ingredientId: json['ingredientId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      ingredient: json['ingredient'] ?? '',
      id: json['id'] ?? '',
      remainder: json['remainder'] ?? '',
      quantity: (json['quantity'] is int)
          ? json['quantity']
          : (json['quantity'] is double)
              ? json['quantity'].round()
              : 0,
      wholeLine: json['wholeLine'] ?? '',
    );
  }
}
