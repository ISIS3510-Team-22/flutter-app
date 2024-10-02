import 'package:flutter/material.dart';
import '../models/mental_health_model.dart';
import '../services/mental_health_service.dart';

class MentalHealthViewModel extends ChangeNotifier {
  final MentalHealthService _service = MentalHealthService();

  List<MentalHealthModel> _mentalHealthRecords = [];
  List<MentalHealthModel> get mentalHealthRecords => _mentalHealthRecords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch records
  Future<void> fetchRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      _mentalHealthRecords = await _service.fetchMentalHealthRecords();
    } catch (e) {
      // Handle error (e.g., show a toast or a snackbar)
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
