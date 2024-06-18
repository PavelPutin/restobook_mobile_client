import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/view/shared_widget/default_text_field.dart';

import '../../../model/utils/validators.dart';

class ClientNameTextField extends StatelessWidget {
  const ClientNameTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      controller: controller,
      labelText: "Имя клиента",
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Поле обязательное";
        }
        if (value.length > 512) {
          return "Имя не должно быть длиннее 512 символов";
        }
        var contentCheck = onlyWordsAndDash(value);
        if (contentCheck != null) {
          return contentCheck;
        }
        return null;
      },
    );
  }
}