import 'package:flutter/material.dart';

import '../../shared_widget/number_text_field.dart';

class TableNumberTextField extends StatelessWidget {
  const TableNumberTextField({super.key, required this.controller, this.errorText});

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return NumberTextField(
        controller: controller,
        labelText: "Номер столика",
        errorText: errorText,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Поле обязательное";
          }
          try {
            if (int.parse(value) < 1) {
              return "Значение должно быть не меньше 1";
            }
          } catch (_) {
            return "Должно быть числом";
          }
          return null;
        });
  }
}
