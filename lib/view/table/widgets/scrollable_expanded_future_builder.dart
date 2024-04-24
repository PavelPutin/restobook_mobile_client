import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScrollableExpandedFutureBuilder extends StatelessWidget {
  const ScrollableExpandedFutureBuilder({super.key, required this.loading, required this.onRefresh, required this.errorLabel, required this.child});

  final Future<void> loading;
  final AsyncCallback onRefresh;
  final Widget errorLabel;
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
                    child: FutureBuilder(
                        future: loading,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  errorLabel,
                                  ElevatedButton(
                                      onPressed: onRefresh,
                                      child: const Text("Попробовать ещё раз"))
                                ],
                              ),
                            );
                          }

                          return child;
                        }),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

}