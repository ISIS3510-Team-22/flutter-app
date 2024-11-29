class InfoMostUsed {
  final String id;
  int adapting;
  int exchanges; // URL de la imagen de perfil (puede ser opcional)
  int mental; // Latitud del usuario
  int recipes;
  int universities;

  InfoMostUsed({
    required this.id,
    required this.adapting,
    required this.exchanges,
    required this.mental,
    required this.recipes,
    required this.universities,
  });

  // Convert a JSON map to an InfoMostUsed instance
  factory InfoMostUsed.fromJson(Map<String, dynamic> json) {
    return InfoMostUsed(
      id: json['id'],
      adapting: json['adapting'],
      exchanges: json['exchanges'],
      mental: json['mental'],
      recipes: json['recipes'],
      universities: json['universities'],
    );
  }

  // Convert an InfoMostUsed instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adapting': adapting,
      'exchanges': exchanges,
      'mental': mental,
      'recipes': recipes,
      'universities': universities,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adapting': adapting,
      'exchanges': exchanges,
      'mental': mental,
      'universities': universities,
    };
  }

  // Create a Recipe object from Firestore data
  factory InfoMostUsed.fromMap(Map<String, dynamic> map, String id) {
    return InfoMostUsed(
      id: id,
      adapting: map['adapting'],
      exchanges: map['exchanges'],
      mental: map['mental'],
      recipes: map['recipes'],
      universities: map['universities'],
    );
  }
}
