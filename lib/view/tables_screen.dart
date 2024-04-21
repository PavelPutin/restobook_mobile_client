import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/widgets/refreshable_future_list_view.dart';
import 'package:restobook_mobile_client/view/widgets/table_list_tile.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late Future<void> tablesLoading;

  @override
  void initState() {
    super.initState();
    tablesLoading = Provider.of<TableViewModel>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableViewModel>(
        builder: (context, tableViewModel, child) {
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
                itemCount: tableViewModel.tables.length,
                itemBuilder: (_, index) => TableListTile(table: tableViewModel.tables[index])
            ),
          );
        }
    );
  }
}