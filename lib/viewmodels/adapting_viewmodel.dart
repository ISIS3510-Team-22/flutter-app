import 'package:flutter/material.dart';
import '../services/adapting_service.dart';
import '../models/adapting_model.dart';

class AdaptingViewModel extends ChangeNotifier {
  final AdaptingService _adaptingModelService = AdaptingService();

  List<AdaptingModel> _adaptingTips = [];
  List<AdaptingModel> get adaptingTips => _adaptingTips;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AdaptingViewModel() {
    fetchAdaptingTips();
  }

  // Fetch adapting models from the service and notify listeners.
  Future<void> fetchAdaptingTips() async {
    _isLoading = true;
    notifyListeners();

    _adaptingTips = await _adaptingModelService.fetchAdaptingModels();

    _isLoading = false;
    notifyListeners();
  }
}
