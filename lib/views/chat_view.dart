import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkBlueColor,
          foregroundColor: Colors.white,
          title: const Text(
            'CHAT',
            style: headerTextStyle,
          ),
        ),
        body: const Text(
          'CHAT HERE',
          style: headerTextStyle,
        ));
  }
}
