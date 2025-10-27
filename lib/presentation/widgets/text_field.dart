import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.hintText,
    required this.controller,
    this.keyboardType,
    super.key,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          // borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.white,
        filled: true,
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 17),
      ),
      keyboardType: keyboardType,
    );
  }
}
