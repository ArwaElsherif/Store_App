import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.hintText,
    this.onChanged,
    this.keyboardType,
    this.controller,
  });

  final String hintText;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? controller; // ✅ أضفت الكونترولر

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // ✅ خليته يستعمل الكونترولر
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderSide: BorderSide()),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
