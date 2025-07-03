import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    required this.text,
    this.fontSize = 16.0, // taille par défaut
    this.color = Colors.black87,
    this.textAlign,
    super.key,
  });
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
