import 'package:flutter/material.dart';

class ScaffoldBodyPadding extends StatelessWidget {
  const ScaffoldBodyPadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}