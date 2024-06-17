import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/table/screens/edit_screen.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

import '../../../view_model/application_view_model.dart';
import '../../shared_widget/info_label.dart';

class TableInfo extends StatelessWidget {
  const TableInfo(
      {super.key, required this.tableLoading, required this.onRetry});

  final Future<void> tableLoading;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Consumer<TableViewModel>(builder: (context, tableViewModel, child) {
      return FutureBuilder(
          future: tableLoading,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Не удалось загрузить стол"),
                    ElevatedButton(
                        onPressed: onRetry,
                        child: const Text("Попробовать ещё раз"))
                  ],
                ),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    InfoLabel(
                        label: "Количество мест:",
                        info:
                            tableViewModel.activeTable!.seatsNumber.toString()),
                  ],
                ),
                Row(
                  children: [
                    InfoLabel(
                        label: "Состояние:",
                        info: switch (tableViewModel.activeTable?.state) {
                          "NORMAL" => "Нормальное",
                          "BROKEN" => "Сломан",
                          // TODO: Handle this case.
                          String() => throw UnimplementedError(),
                          // TODO: Handle this case.
                          null => throw UnimplementedError(),
                        }),
                  ],
                ),
                Row(
                  children: [
                    InfoLabel(label: "Комментарий:", info: tableViewModel.activeTable?.comment ?? '-')
                  ],
                ),
                if (context.read<ApplicationViewModel>().isAdmin)
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TableEditScreen(
                                      table: tableViewModel.activeTable!))),
                          child: const Row(
                            children: [
                              Icon(Icons.edit),
                              Text("Редактировать"),
                            ],
                          ))
                    ],
                  )
              ],
            );
          });
    });
  }
}
