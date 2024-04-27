import 'package:flutter/material.dart';

class ReservationStateDropdownMenu extends StatelessWidget {
  const ReservationStateDropdownMenu({super.key, required this.initialValue, required this.onChanged});

  final String initialValue;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Состояние"),
      items: const [
        DropdownMenuItem<String>(
            value: "WAITING", child: Text("Ожидает")),
        DropdownMenuItem<String>(
            value: "OPEN", child: Text("Открыта")),
        DropdownMenuItem<String>(
            value: "CLOSED", child: Text("Закрыта"))
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