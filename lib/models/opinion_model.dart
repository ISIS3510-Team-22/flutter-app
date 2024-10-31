class Opinion {
  final String name;
  final String id;
  final double rating;
  final String comment;

  Opinion({
    required this.id,
    required this.name,
    required this.rating,
    required this.comment,
  });

  factory Opinion.fromMap(Map<String, dynamic> data, String id) {
    return Opinion(
      id: id, // Set the id from the passed parameter
      name: data['name'] as String,
      rating: (data['rating'] as num).toDouble(),
      comment: data['comment'] as String,
    );
  }
}
