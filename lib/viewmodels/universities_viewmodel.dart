import 'package:flutter/material.dart';
import '../services/university_service.dart'; // Import the service
import '../models/university_model.dart';

class UniversityViewModel extends ChangeNotifier {
  final UniversityService _universityService = UniversityService();

  List<University> _universities = [];
  List<University> get universities => _universities;

  void fetchUniversities() {
    _universityService.fetchUniversities().listen((universityList) {
      _universities = universityList;
      notifyListeners(); // Notifies the View to rebuild with new data
    });
  }
}
