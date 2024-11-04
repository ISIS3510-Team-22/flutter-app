class Opinion {
  final String name;
  final String id;
  final double rating;
  final String comments;

  Opinion({
    required this.id,
    required this.name,
    required this.rating,
    required this.comments,
  });

  factory Opinion.fromMap(Map<String, dynamic> data, String id) {
    return Opinion(
      id: id, // Set the id from the passed parameter
      name: data['name'] as String,
      rating: (data['rating'] as num).toDouble(),
      comments: data['comments'] as String,
    );
  }
}
