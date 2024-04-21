import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/table_view_model.dart';

class TableTitleFutureBuilder extends StatelessWidget {
  const TableTitleFutureBuilder({super.key, required this.tableLoading});

  final Future<void> tableLoading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tableLoading,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            strokeAlign: CircularProgressIndicator.strokeAlignInside,
            strokeWidth: 2,
          );
        }

        if (snapshot.hasError) {
          return const Text("Ошибка загрузки");
        }

        return Consumer<TableViewModel>(
            builder: (context, tableViewModel, child) {
              return Text("Стол ${tableViewModel.activeTable?.number}");
            });
      },
    );
  }

}