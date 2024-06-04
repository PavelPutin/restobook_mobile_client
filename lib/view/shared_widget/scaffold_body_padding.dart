import 'package:flutter/material.dart';

class ScaffoldBodyPadding extends StatelessWidget {
  const ScaffoldBodyPadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
      child: child,
    );
  }
}