import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/searched_queries_service.dart';

class SearchedQueriesViewModel extends ChangeNotifier {
  // Utility method to check connectivity
  Future<bool> _checkConnectivity() async {
    return (await Connectivity().checkConnectivity())
        .contains(ConnectivityResult.none);
  }

  // Update a specific field with connectivity check
  void addQuery(String query) async {
    if (await _checkConnectivity()) {
      log("No internet connection. Cannot add query.");
    } else {
      final SearchedQueriesService searchedQueriesService =
          SearchedQueriesService();
      searchedQueriesService.addQuery("queries", query);
    }
  }
}
