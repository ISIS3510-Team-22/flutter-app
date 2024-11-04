class InfoMostUsed {
  final String id;
  final int adapting;
  final int exchanges; // URL de la imagen de perfil (puede ser opcional)
  final int mental; // Latitud del usuario
  final int recipes;
  final int universities;

  InfoMostUsed({
    required this.id,
    required this.adapting,
    required this.exchanges,
    required this.mental,
    required this.recipes,
    required this.universities,
  });

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
