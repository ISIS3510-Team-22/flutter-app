import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CookingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cooking & Recipes', style: headerTextStyle),
        backgroundColor: darkBlueColor,
      ),
      body: Center(
        child: Text(
          'Here you will find recipes for cooking while abroad.',
          style: bodyTextStyle,
        ),
      ),
    );
  }
}
