import 'package:flutter/material.dart';
import '../constants/constants.dart';

class AiHelperView extends StatelessWidget {
  const AiHelperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkBlueColor,
          foregroundColor: Colors.white,
          title: const Text(
            'AI HELPER',
            style: headerTextStyle,
          ),
        ),
        body: const Text(
          'AI HELPER HERE HERE',
          style: headerTextStyle,
        ));
  }
}
