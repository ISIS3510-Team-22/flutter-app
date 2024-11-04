import 'package:flutter/material.dart';
import '../constants/constants.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkBlueColor,
          foregroundColor: Colors.white,
          title: const Text(
            'NEWS',
            style: headerTextStyle,
          ),
        ),
        body: const Text(
          'NEWS HERE',
          style: headerTextStyle,
        ));
  }
}
