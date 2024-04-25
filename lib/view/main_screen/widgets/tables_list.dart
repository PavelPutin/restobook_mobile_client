import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/table_list_tile.dart';
import 'package:restobook_mobile_client/view/table/screens/creation_screen.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

class TablesList extends StatefulWidget {
  const TablesList({super.key});

  @override
  State<TablesList> createState() => _TablesListState();
}

class _TablesListState extends State<TablesList> {
  late Future<void> tablesLoading;

  @override
  void initState() {
    super.initState();
    tablesLoading = Provider.of<TableViewModel>(context, listen: false).load();
  }

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
        onRefresh: () async {
          var promise = context.read<TableViewModel>().load();
          setState(() {
            tablesLoading = promise;
          });
          await promise;
        },
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
