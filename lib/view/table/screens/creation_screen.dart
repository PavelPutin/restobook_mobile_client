import 'package:flutter/material.dart';

class TableCreationScreen extends StatelessWidget {
  const TableCreationScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Новый стол")
      ),
      body: const Center(
        child: Text("Table creation"),
      ),
    );
  }
}