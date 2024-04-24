import 'package:flutter/material.dart';

class CreationReservationScreen extends StatelessWidget {
  const CreationReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded)
        ),
        title: const Text("Новая бронь"),
      ),
      body: const Center(
        child: Text("Reservation"),
      ),
    );
  }
}