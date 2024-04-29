import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/view/shared_widget/default_text_field.dart';

class ClientPhoneNumberTextField extends StatelessWidget {
  const ClientPhoneNumberTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      controller: controller,
      labelText: "Номер клиента",
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Поле обязательное";
        }
        if (value.length > 30) {
          return "Номер не должен быть длиннее 30 символов";
        }
        return null;
      },
    );
  }
}
