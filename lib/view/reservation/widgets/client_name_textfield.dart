import 'package:flutter/material.dart';

class ClientNameTextField extends StatelessWidget {
  const ClientNameTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Имя клиента"),
    );
  }
}