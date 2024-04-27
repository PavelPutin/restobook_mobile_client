import 'package:flutter/material.dart';

class ScrollableExpanded extends StatelessWidget {
  const ScrollableExpanded({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}