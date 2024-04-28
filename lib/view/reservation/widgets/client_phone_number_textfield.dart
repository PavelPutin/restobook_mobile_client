import 'package:flutter/material.dart';

class ClientPhoneNumberTextField extends StatelessWidget {
  const ClientPhoneNumberTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: controller,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Номер клиента"),
    );
  }
}