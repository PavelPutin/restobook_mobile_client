import 'package:flutter/cupertino.dart';

import '../../shared_widget/number_text_field.dart';

class PersonsNumberTextField extends StatelessWidget {
  const PersonsNumberTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return NumberTextField(
        controller: controller,
        labelText: "Количество гостей");
  }
}