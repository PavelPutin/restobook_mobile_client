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
          if (value == null || value.isEmpty) {
            return "Поле обязательное";
          }
          if (int.parse(value) < 1) {
            return "Значение должно быть не меньше 1";
          }
          return null;
        });
  }
}
