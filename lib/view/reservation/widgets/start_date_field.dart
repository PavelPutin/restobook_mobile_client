import 'package:flutter/material.dart';

class StartDateField extends StatelessWidget {
  const StartDateField(
      {super.key,
      required this.controller,
      required this.blockEditing,
      required this.onChange});

  final TextEditingController controller;
  final VoidCallback blockEditing;
  final Function(DateTime?) onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.none,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "Дата"),
        onChanged: (value) => blockEditing(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Поле обязательное";
          }
          return null;
        },
        onTap: () {
          Future<DateTime?> selectedDate = showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 31)),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              });
          selectedDate.then((value) => onChange(value));
        });
  }
}
