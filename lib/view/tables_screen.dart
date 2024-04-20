import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/view/widgets/table_list_tile.dart';
import 'package:restobook_mobile_client/view_model/table_view_model.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late Future<void> tablesLoading;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    tablesLoading = Provider.of<TableViewModel>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableViewModel>(
        builder: (context, tableViewModel, child) {
          return RefreshIndicator(
            onRefresh: () async {
              var promise = context.read<TableViewModel>().load();
              setState(() {
                _refreshing = true;
                tablesLoading = promise;
              });
              await promise;
            },
            child: FutureBuilder(
              future: tablesLoading,
              builder: (ctx, snapshot) {
                if (!_refreshing && snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Не удалось загрузить столы"),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _refreshing = false;
                                tablesLoading =
                                    context.read<TableViewModel>().load();
                              });
                            },
                            child: const Text("Попробовать ещё раз"))
                      ],
                    ),
                  );
                }

                return ListView.builder(
                    itemCount: tableViewModel.tables.length,
                    itemBuilder: (_, index) => TableListTile(table: tableViewModel.tables[index])
                );
              },
            ),
          );
        }
    );
  }
}