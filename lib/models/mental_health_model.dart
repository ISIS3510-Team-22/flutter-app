import 'package:cloud_firestore/cloud_firestore.dart';

class MentalHealthModel {
  String? id;
  String title;
  String description;
  DateTime createdAt;

  MentalHealthModel({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  // From Firebase snapshot to model
  factory MentalHealthModel.fromMap(Map<String, dynamic> map, String id) {
    return MentalHealthModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // To map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
