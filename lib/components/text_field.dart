import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;
  final bool obscureText;

  const MyTextField(
      {super.key,
      required this.fieldName,
      required this.controller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: fieldName,
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.grey.shade400,
          )),
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
      ),
    );
  }
}
