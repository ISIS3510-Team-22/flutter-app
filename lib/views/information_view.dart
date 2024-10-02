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
                Navigator.pushNamed(context, '/recipes');
              },
            ),
            const InformationTile(title: 'Mental Health'),
            const InformationTile(title: 'Adapting to a new city'),
            const InformationTile(title: 'Universities info'),
            const InformationTile(title: 'Current exchanges available'),
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
