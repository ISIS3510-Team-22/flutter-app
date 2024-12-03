import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/models/opinion_model.dart';
import 'package:studyglide/models/university_model.dart';
import 'package:studyglide/services/university_service.dart';
import 'package:studyglide/widgets/customAppBar.dart';
import 'package:uuid/uuid.dart';

class AddReviewView extends StatelessWidget {
  late Box _offlineOpinionsBox;
  final University university;
  final TextEditingController commentController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final UniversityService universityService = UniversityService();
  final Connectivity _connectivity = Connectivity();
  var uuid = Uuid();
  User? currentUser = FirebaseAuth.instance.currentUser;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  AddReviewView(this.university, {super.key}) {
    _initialize();
  }

  void _initialize() async {
    _offlineOpinionsBox = await Hive.openBox('offline_opinions');
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        _sendOfflineOpinions();
      }
    });
  }

  Future<void> _sendOfflineOpinions() async {
    final opinions =
        List<Opinion>.from(_offlineOpinionsBox.values.cast<Opinion>());
    if (opinions.isNotEmpty) {
      for (var opinion in opinions) {
        universityService.addOpinion(university.id, opinion);
      }
      _offlineOpinionsBox.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2139),
      appBar: CustomAppBar(title: university.name.toUpperCase()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // University Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3853),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // University Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          university
                              .imageUrl, // Replace with university image URL.
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // University Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow("Country:", university.country),
                            const SizedBox(height: 8),
                            _buildDetailRow("City:", university.city),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                                "# Students:", university.students.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Rating and Comment Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3853),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Rating Input
                      Row(
                        children: [
                          const Text(
                            "Digit the rate: ",
                            style: bodyTextStyle,
                          ),
                          Expanded(
                            child: TextField(
                              controller: rateController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "0-5",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFF1A3853),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      // Comment Input
                      TextField(
                        controller: commentController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "Write your comment...",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFF1A3853),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16.0),
                      // Send Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A3853),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            final rate = double.tryParse(rateController.text);
                            final comment = commentController.text.trim();

                            if (rate == null || rate < 0 || rate > 5) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please enter a valid rate (0-5)."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            if (comment.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Comment cannot be empty."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            //Create the opninon object
                            final opinion = Opinion(
                              // Create a random id for the opinion
                              id: uuid.v4(),
                              name: 'Anonymous',
                              rating: rate,
                              comment: comment,
                            );
                            // Check if there is internet connection
                            if (_connectivity.checkConnectivity() ==
                                ConnectivityResult.none) {
                              _offlineOpinionsBox.put(opinion.id, opinion);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "No internet connection. The review will be sent when the connection is restored."),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            } else {
                              universityService.addOpinion(
                                  university.id, opinion);
                              // Logic to save the review
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Review submitted successfully!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }

                            // Clear fields
                            rateController.clear();
                            commentController.clear();
                          },
                          child: const Text(
                            "Send",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Function to Build University Details Row
Widget _buildDetailRow(String title, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "• ",
        style: bodyTextStyle,
      ),
      RichText(
        text: TextSpan(
          style: subBodyTextStyle,
          children: [
            TextSpan(
              text: title,
              style: bodyTextStyle,
            ),
            TextSpan(text: " $value"),
          ],
        ),
      ),
    ],
  );
}
