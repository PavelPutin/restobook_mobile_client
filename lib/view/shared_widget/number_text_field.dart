import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextField extends StatelessWidget {
  const NumberTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.validator});

  final TextEditingController controller;
  final String labelText;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLines: null,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), labelText: labelText),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      validator: validator,
    );
  }
}
