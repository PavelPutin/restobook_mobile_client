import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeatsNumberTextField extends StatelessWidget {
  const SeatsNumberTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLines: null,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "Количество мест"),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ]);
  }
}
