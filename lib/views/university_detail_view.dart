import 'package:flutter/material.dart';
import 'package:studyglide/views/add_opinion_view.dart';
import '../constants/constants.dart';
import '../models/university_model.dart';
import '../models/opinion_model.dart';

class UniversityDetailView extends StatelessWidget {
  final University university;

  const UniversityDetailView({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2139), // Dark blue background color.
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2139),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          university.name.toUpperCase(),
          style: headerTextStyle,
        ),
        centerTitle: true,
      ),
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
                          university.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Image failed\nto load',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red),
                              ),
                            );
                          },
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
            // Reviews Section
            ...university.opinions.map((review) => _buildReviewCard(review)),
            // Add Review Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddReviewView(university), // Pass the university object.
                    ),
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A3853),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildReviewCard(Opinion opinion) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A3853),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(
                  Icons.person,
                  color: Color(0xFF0D2139),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opinion.name,
                      style: bodyTextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      opinion.comment,
                      style: subBodyTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Text(
                    opinion.rating.toString(),
                    style: bodyTextStyle,
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
