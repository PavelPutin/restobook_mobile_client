import 'package:flutter/material.dart';

import '../../shared_widget/number_text_field.dart';

class TableNumberTextField extends StatelessWidget {
  const TableNumberTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return NumberTextField(
        controller: controller, labelText: "Номер столика");
  }
}
