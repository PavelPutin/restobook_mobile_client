import 'package:flutter/material.dart';

import '../reservation/creation_reservation_screen.dart';

class FloatingCreationReservationButton extends StatelessWidget {
  const FloatingCreationReservationButton({super.key});


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreationReservationScreen()))
      },
      icon: const Icon(Icons.add),
      label: const Text("Новая бронь"),
    );
  }
}