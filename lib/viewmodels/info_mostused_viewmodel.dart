import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/info_mostused_model.dart';
import '../services/info_mostused_service.dart';

class InfoMostUsedViewModel extends ChangeNotifier {
  InfoMostUsed _infoMostUseds = InfoMostUsed(
      id: "0",
      adapting: 0,
      exchanges: 0,
      mental: 0,
      recipes: 0,
      universities: 0);

  InfoMostUsed get infoMostUseds => _infoMostUseds;

  // Utility method to check connectivity
  Future<bool> _checkConnectivity() async {
    return (await Connectivity().checkConnectivity())
        .contains(ConnectivityResult.none);
  }

  // Fetch most used info with connectivity check
  void getMostUsed() async {
    // Check local storage first before fetching from the API
    final prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('infoMostUsed');
    if (storedData != null) {
      _infoMostUseds = InfoMostUsed.fromJson(jsonDecode(storedData));
      notifyListeners(); // Notify listeners if we load from local storage
    }
    if (await _checkConnectivity()) {
      log("No internet connection. Cannot fetch most used info.");
    } else {
      final InfoMostUsedService infoMostUsedService = InfoMostUsedService();
      infoMostUsedService.getInfoMostUsed().listen((infoList) {
        _infoMostUseds = infoList[0];
        notifyListeners(); // Notifies the View to rebuild with new data

        // Save the fetched data to Shared Preferences
        prefs.setString('infoMostUsed', jsonEncode(_infoMostUseds.toJson()));
      });
    }
  }

  // Update a specific field with connectivity check
  void updateField(String field) async {
    if (await _checkConnectivity()) {
      log("No internet connection. Cannot update field.");
    } else {
      final InfoMostUsedService infoMostUsedService = InfoMostUsedService();
      infoMostUsedService.incrementField("uses", field);

      // After updating, save the new data to Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('infoMostUsed', jsonEncode(_infoMostUseds.toJson()));
    }
  }
}
