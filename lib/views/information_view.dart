import 'package:flutter/material.dart';
import '../constants/constants.dart';

class InformationView extends StatelessWidget {
  const InformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: const Text(
          'INFORMATION',
          style: headerTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Action for calendar icon
            },
          ),
        ],
      ),
      body: Container(
        color: darkBlueColor,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            InformationTile(
              title: 'Cooking & recipes while abroad',
              onTap: () {
                // Navigate to the Recipe List View
                Navigator.pushNamed(context, '/information/recipes');
              },
            ),
            InformationTile(
              title: 'Mental Health',
              onTap: () {
                // Navigate to the Recipe List View
                Navigator.pushNamed(context, '/information/mental_health');
              },
            ),
            InformationTile(
              title: 'Adapting to a new city',
              onTap: () {
                // Navigate to the Recipe List View
                Navigator.pushNamed(context, '/information/adapting_tips');
              },
            ),
            InformationTile(
              title: 'Universities info',
              onTap: () {
                // Navigate to the Recipe List View
                Navigator.pushNamed(context, '/information/universities_info');
              },
            ),
            InformationTile(
              title: 'Current exchanges available',
              onTap: () {
                // Navigate to the Recipe List View
                Navigator.pushNamed(context, '/information/exchanges');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InformationTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap; // Add a callback for handling taps

  const InformationTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onTap, // Call the onTap function when tapped
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: grayBlueColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: buttonTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
