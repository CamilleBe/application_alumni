import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign? textAlign;

  const CustomText({
    required this.text,
    this.fontSize = 16.0, // taille par défaut
    this.color = Colors.black87,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}
