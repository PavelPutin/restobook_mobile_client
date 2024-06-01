import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextField extends StatelessWidget {
  const NumberTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.validator, this.errorText});

  final TextEditingController controller;
  final String labelText;
  final String? Function(String? value)? validator;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLines: null,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), labelText: labelText, errorText: errorText),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      validator: validator,
    );
  }
}
