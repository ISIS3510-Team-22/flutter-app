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
    } else {
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
  }

  void updateField(String field) async {
    // Save the field update locally
    _incrementLocalField(field); // Update the local state
    notifyListeners(); // Notify listeners to rebuild the UI with updated local data

    // Check connectivity
    if (await _checkConnectivity()) {
      log("No internet connection. Field update saved locally, will sync later.");
    } else {
      final InfoMostUsedService infoMostUsedService = InfoMostUsedService();

      // Send the update to the database
      infoMostUsedService.incrementField("uses", field).then((_) async {
        // Once the data is successfully updated in the database, sync with local storage
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('infoMostUsed', jsonEncode(_infoMostUseds.toJson()));
        log("Field synchronized with database and local storage updated.");
      }).catchError((error) {
        log("Failed to synchronize field with database: $error");
      });
    }
  }

  void _incrementLocalField(String field) {
    // Increment the appropriate field locally
    if (field == "adapting") {
      _infoMostUseds.adapting++;
    } else if (field == "exchanges") {
      _infoMostUseds.exchanges++;
    } else if (field == "mental") {
      _infoMostUseds.mental++;
    } else if (field == "recipes") {
      _infoMostUseds.recipes++;
    } else if (field == "universities") {
      _infoMostUseds.universities++;
    }

    // Save the updated object to SharedPreferences immediately after the change
    _saveToLocalStorage();
  }

  void _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('infoMostUsed', jsonEncode(_infoMostUseds.toJson()));
  }
}
