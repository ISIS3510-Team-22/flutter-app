import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const CustomButton(
      {super.key,
      required this.label,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(label, style: buttonTextStyle),
    );
  }
}
