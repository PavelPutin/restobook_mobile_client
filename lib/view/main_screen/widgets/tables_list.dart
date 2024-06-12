import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/table_list_tile.dart';
import 'package:restobook_mobile_client/view/table/screens/creation_screen.dart';
import 'package:restobook_mobile_client/view_model/application_view_model.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

final Logger logger = GetIt.I<Logger>();

class TablesList extends StatelessWidget {
  const TablesList({super.key, required this.tablesLoading, required this.onRefresh});

  final Future<void> tablesLoading;
  final AsyncCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    logger.t("Build tables_list");
    return Consumer<TableViewModel>(builder: (context, tableViewModel, child) {
      logger.t("Consumer table view model in tables_list updated");
      bool isAdmin = context.read<ApplicationViewModel>().isAdmin;
      var itemCount = tableViewModel.tables.length;
      if (isAdmin) {
        itemCount += 1;
      }

      Widget tablesListContent;
      if (tableViewModel.tables.isNotEmpty) {
        tablesListContent = ListView.builder(
            itemCount: itemCount,
            itemBuilder: (_, index) {
              if (index == tableViewModel.tables.length && isAdmin) {
                return ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TableCreationScreen())),
                    child: const Text("Добавить стол"));
              }

              return ColorIndicatedTableListTile(table: tableViewModel.tables[index]);
            });
      } else {
        tablesListContent = Center(
            child: Column(
              children: [
                const Text("Нет столов"),
                if (isAdmin)
                  ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TableCreationScreen())),
                      child: const Text("Добавить стол"))
              ]
            )
        );
      }

      return RefreshableFutureListView(
        tablesLoading: tablesLoading,
        // onRefresh: () async {
        //   var promise = context.read<TableViewModel>().load();
        //   promise.onError((error, stackTrace) {print(error); print(stackTrace);});
        //   setState(() {
        //     tablesLoading = promise;
        //   });
        //   await promise;
        // },
        onRefresh: onRefresh,
        errorLabel: "Не удалось загрузить столы",
        listView: tablesListContent,
      );
    });
  }
}
