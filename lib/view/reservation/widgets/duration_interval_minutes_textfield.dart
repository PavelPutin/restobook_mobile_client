import 'package:flutter/material.dart';

import '../../shared_widget/number_text_field.dart';

class DurationIntervalMinutesTextField extends StatelessWidget {
  const DurationIntervalMinutesTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return NumberTextField(
      controller: controller,
      labelText: "Длительность (в минутах)",
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Поле обязательное";
        }
        try {
          if (int.parse(value) < 5) {
            return "Длительность не должна быть меньше 5 минут";
          }
        } catch (_) {
          return "Должно быть числом";
        }
        return null;
      },
    );
  }
}
