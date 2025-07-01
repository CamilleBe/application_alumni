import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontsize;
  final FontWeight fontWeight;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;

  const WhiteButton({
    required this.text,
    this.textColor = Colors.red,
    this.fontsize = 18.0,
    this.fontWeight = FontWeight.bold,
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.borderRadius = 10.0,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.hovered)
              ? Colors.red
              : backgroundColor,
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) =>
              states.contains(WidgetState.hovered) ? Colors.white : textColor,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(padding),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontsize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
