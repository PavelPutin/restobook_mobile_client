import 'package:flutter/material.dart';

import '../../shared_widget/number_text_field.dart';

class SeatsNumberTextField extends StatelessWidget {
  const SeatsNumberTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return NumberTextField(
      controller: controller,
      labelText: "Количество мест"
    );
  }
}
