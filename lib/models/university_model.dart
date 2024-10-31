import './opinion_model.dart';

class University {
  final String id;
  final String city;
  final String country;
  final String name;
  final int students;
  final List<Opinion> opinions;

  University({
    required this.id,
    required this.city,
    required this.country,
    required this.name,
    required this.students,
    required this.opinions,
  });

  factory University.fromMap(
      Map<String, dynamic> data, String id, List<Opinion> opinions) {
    return University(
      id: id,
      name: data['name'] as String,
      city: data['city'] as String,
      country: data['country'] as String,
      students: data['students'] as int,
      opinions: opinions,
    );
  }
}
