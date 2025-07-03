import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    required this.text,
    this.fontSize = 24.0, // taille par défaut
    this.fontWeight = FontWeight.bold, // graisse par défaut
    this.textAlign = TextAlign.start, // alignement par défaut
    super.key,
  });
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
