import 'package:flutter/material.dart';

import '../creation_reservation_screen.dart';

class FloatingCreationReservationButton extends StatelessWidget {
  const FloatingCreationReservationButton({super.key});


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreationReservationScreen()))
      },
      child: const Icon(Icons.add),
    );
  }
}