import 'package:flutter/material.dart';

class IconButtonNavigatorPop extends StatelessWidget {
  const IconButtonNavigatorPop({super.key});


  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded)
    );
  }
}