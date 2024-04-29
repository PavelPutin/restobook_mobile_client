import 'package:flutter/material.dart';

class CommentTextField extends StatelessWidget {
  const CommentTextField({super.key, required this.controller, this.validator});

  final TextEditingController controller;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Комментарий"),
      validator: validator,
    );
  }
}
