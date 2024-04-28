import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/table_list_tile.dart';
import 'package:restobook_mobile_client/view/table/screens/creation_screen.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

class TablesList extends StatelessWidget {
  const TablesList({super.key, required this.tablesLoading, required this.onRefresh});

  final Future<void> tablesLoading;
  final AsyncCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Consumer<TableViewModel>(builder: (context, tableViewModel, child) {
      bool isAdmin = const String.fromEnvironment("USER_TYPE") == "ADMIN";
      var itemCount = tableViewModel.tables.length;
      if (isAdmin) {
        itemCount += 1;
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
        listView: ListView.builder(
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

              return TableListTile(table: tableViewModel.tables[index]);
            }),
      );
    });
  }
}
