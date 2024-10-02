class AdaptingModel {
  final String id;
  final String title;
  final String description;

  AdaptingModel(
      {required this.id, required this.title, required this.description});

  // Factory method to create an AdaptingModel from a Firestore document.
  factory AdaptingModel.fromFirestore(Map<String, dynamic> json, String id) {
    return AdaptingModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Converts the AdaptingModel object into a Map for saving into Firestore (if needed).
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
    };
  }
}
