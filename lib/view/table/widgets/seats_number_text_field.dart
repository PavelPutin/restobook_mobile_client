import 'package:flutter/material.dart';

import '../../shared_widget/number_text_field.dart';

class SeatsNumberTextField extends StatelessWidget {
  const SeatsNumberTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return NumberTextField(
        controller: controller,
        labelText: "Количество мест",
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
