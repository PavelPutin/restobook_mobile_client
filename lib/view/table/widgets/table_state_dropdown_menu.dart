import 'package:flutter/material.dart';

class TableStateDropdownMenu extends StatelessWidget {
  const TableStateDropdownMenu({super.key, required this.initialValue, required this.onChanged});

  final String initialValue;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Состояние"),
      items: const [
        DropdownMenuItem<String>(
            value: "NORMAL", child: Text("Нормальный")),
        DropdownMenuItem<String>(
            value: "BROKEN", child: Text("Сломаный"))
      ],
      onChanged: (String? selected) {
        if (selected is String) {
          onChanged(selected);
        }
      },
      value: initialValue,
    );
  }

}