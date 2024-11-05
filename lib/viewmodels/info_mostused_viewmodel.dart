import 'package:flutter/material.dart';
import '../models/info_mostused_model.dart';
import '../services/info_mostused_service.dart';

class InfoMostUsedViewModel extends ChangeNotifier {
  final InfoMostUsedService _infoMostUsedService = InfoMostUsedService();

  InfoMostUsed _infoMostUseds = InfoMostUsed(
      id: "0",
      adapting: 0,
      exchanges: 0,
      mental: 0,
      recipes: 0,
      universities: 0);
  InfoMostUsed get infoMostUseds => _infoMostUseds;

  // Fetch recipes and notify the view
  void getMostUsed() {
    _infoMostUsedService.getInfoMostUsed().listen((infoList) {
      _infoMostUseds = infoList[0];
      notifyListeners(); // Notifies the View to rebuild with new data
    });
  }

  void updateField(String field) {
    _infoMostUsedService.incrementField("uses", field);
  }
}
