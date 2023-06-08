import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String fieldName;
  final TextEditingController controller;
  final bool obscureText;

  const PasswordTextField(
      {super.key,
      required this.fieldName,
      required this.controller,
      required this.obscureText});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late final String fieldName;
  late final TextEditingController controller;
  late final bool obscureText;

  _PasswordTextFieldState();

  @override
  void initState() {
    fieldName = widget.fieldName;
    controller = widget.controller;
    obscureText = widget.obscureText;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
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
