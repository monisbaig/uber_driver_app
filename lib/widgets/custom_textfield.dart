import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final TextInputType? type;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.text,
    this.type,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: text,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
