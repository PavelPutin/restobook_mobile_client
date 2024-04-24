import 'package:flutter/material.dart';

class TitleFutureBuilder extends StatelessWidget {
  const TitleFutureBuilder({super.key, required this.loading, required this.errorMessage, required this.title});

  final Future<void> loading;
  final Widget errorMessage;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loading,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              strokeAlign: CircularProgressIndicator.strokeAlignInside,
              strokeWidth: 2,
            ),
          );
        }

        if (snapshot.hasError) {
          return errorMessage;
        }

        return title;
      },
    );
  }

}