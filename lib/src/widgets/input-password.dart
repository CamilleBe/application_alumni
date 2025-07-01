import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String label;
  final String hintText;
  final double borderRadius;
  final double margin;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;
  final TextEditingController controller;

  const PasswordInput({
    required this.label,
    required this.hintText,
    this.borderRadius = 10.0,
    this.margin = 8.0,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 16.0,
    required this.controller,
    super.key,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(widget.margin),
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          filled: true,
          fillColor: widget.backgroundColor.withOpacity(0.1),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}
