import 'package:flutter/material.dart';
import '../constants/constants.dart';

class MentalHealthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health', style: headerTextStyle),
        backgroundColor: darkBlueColor,
      ),
      body: Center(
        child: Text(
          'Content about mental health for exchange students.',
          style: bodyTextStyle,
        ),
      ),
    );
  }
}
