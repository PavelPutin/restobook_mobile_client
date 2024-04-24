import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/table/screens/edit_screen.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';


class TableInfo extends StatelessWidget {
  const TableInfo({super.key, required this.tableLoading, required this.onRetry});

  final Future<void> tableLoading;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Consumer<TableViewModel>(
        builder: (context, tableViewModel, child) {
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
                      Text("Количество мест: ${tableViewModel.activeTable?.seatsNumber}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Состояние стола: ${tableViewModel.activeTable?.state}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Комментарий: ${tableViewModel.activeTable?.comment}")
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TableEditScreen(
                                              table: tableViewModel.activeTable!
                                          )
                                  )
                              ),
                          child: const Row(
                            children: [
                              Icon(Icons.edit),
                              Text("Редактировать"),
                            ],
                          )
                      )
                    ],
                  )
                ],
              );
            });
        }
    );
  }
}