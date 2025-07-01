import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomTitle({
    required this.text,
    this.fontSize = 24.0, // taille par défaut
    this.fontWeight = FontWeight.bold, // graisse par défaut
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
