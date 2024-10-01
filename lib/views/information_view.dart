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
          children: const [
            InformationTile(title: 'Cooking & recipes while abroad'),
            InformationTile(title: 'Mental Health'),
            InformationTile(title: 'Adapting to a new city'),
            InformationTile(title: 'Universities info'),
            InformationTile(title: 'Current exchanges available'),
          ],
        ),
      ),
    );
  }
}

class InformationTile extends StatelessWidget {
  final String title;

  const InformationTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 80,
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
    );
  }
}
