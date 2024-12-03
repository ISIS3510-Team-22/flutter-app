import './opinion_model.dart';

class University {
  final String id;
  final String city;
  final String country;
  final String name;
  final String imageUrl;
  final int students;
  final List<Opinion> opinions;

  University({
    required this.id,
    required this.city,
    required this.country,
    required this.name,
    required this.students,
    required this.opinions,
    required this.imageUrl,
  });

  factory University.fromMap(
      Map<String, dynamic> data, String id, List<Opinion> opinions) {
    return University(
      id: id,
      name: data['name'] as String,
      city: data['city'] as String,
      country: data['country'] as String,
      imageUrl: data['imageUrl'] as String,
      students: data['students'] as int,
      opinions: opinions,
    );
  }

  double get averageRating {
    if (opinions.isEmpty) return 0.0;
    double total = opinions.fold(0.0, (sum, opinion) => sum + opinion.rating);
    return total / opinions.length;
  }
}
