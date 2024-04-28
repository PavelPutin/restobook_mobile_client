import 'package:flutter/material.dart';

class StartTimeField extends StatelessWidget {
  const StartTimeField(
      {super.key,
      required this.controller,
      required this.initialTime,
      required this.blockEditing,
      required this.onChange});

  final TextEditingController controller;
  final TimeOfDay initialTime;
  final VoidCallback blockEditing;
  final Function(TimeOfDay?) onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.none,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "Время"),
        onChanged: (value) => blockEditing(),
        onTap: () {
          Future<TimeOfDay?> selectedTime = showTimePicker(
              context: context,
              initialTime: initialTime,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              });
          selectedTime.then((value) => onChange(value));
        });
  }
}
