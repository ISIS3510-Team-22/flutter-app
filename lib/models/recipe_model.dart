class Recipe {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final String instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
  });

  // Convert a Recipe object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  // Create a Recipe object from Firestore data
  factory Recipe.fromMap(Map<String, dynamic> map, String id) {
    return Recipe(
      id: id,
      name: map['name'],
      description: map['description'],
      ingredients: List<String>.from(map['ingredients']),
      instructions: map['instructions'],
    );
  }
}
