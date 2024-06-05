import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/table_selection_tile.dart';
import 'package:restobook_mobile_client/view/shared_widget/refreshable_future_list_view.dart';

import '../../../view_model/application_view_model.dart';
import '../../../view_model/table_view_model.dart';

class TableSelectionDialog extends StatefulWidget {
  const TableSelectionDialog({
    super.key,
    required this.alreadySelectedTables,
    required this.targetDateTime,
    required this.onSelected,
  });

  final List<TableModel> alreadySelectedTables;
  final DateTime targetDateTime;
  final Function(List<TableModel> selected) onSelected;

  @override
  State<TableSelectionDialog> createState() => _TableSelectionDialogState();
}

class _TableSelectionDialogState extends State<TableSelectionDialog> {
  late Future<void> tablesLoading;
  List<TableModel> values = [];
  List<TableModel> selectedValues = [];
  Set<int> alreadySelectedTableIds = {};

  @override
  void initState() {
    super.initState();
    for (var t in widget.alreadySelectedTables) {
      alreadySelectedTableIds.add(t.id!);
    }
    loadTables();
  }

  void loadTables() {
    int restaurantId = context
        .read<ApplicationViewModel>()
        .authorizedUser!
        .employee
        .restaurantId!;
    tablesLoading = Provider.of<TableViewModel>(context, listen: false)
        .loadWithDateTime(restaurantId, widget.targetDateTime);
    tablesLoading.then((value) {
      for (var t
          in Provider.of<TableViewModel>(context, listen: false).tables) {
        if (!alreadySelectedTableIds.contains(t.id!)) {
          values.add(t);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Выберите столы"),
      content: SizedBox(
        width: 250,
        height: 400,
        child: RefreshableFutureListView(
            tablesLoading: tablesLoading,
            onRefresh: () async {
              int restaurantId = context
                  .read<ApplicationViewModel>()
                  .authorizedUser!
                  .employee
                  .restaurantId!;
              var promise = context
                  .read<TableViewModel>()
                  .loadWithDateTime(restaurantId, widget.targetDateTime);
              setState(() => loadTables());
              await promise;
            },
            listView: Builder(
              builder: (context) => values.isEmpty
                  ? const Center(child: Text("Нет доступных столов"))
                  : ListView.separated(
                      itemCount: values.length,
                      itemBuilder: (context, index) {
                        return TableSelectionTile(
                            table: values[index],
                            title: Text("Стол ${values[index].number}"),
                            onTap: () {
                              setState(() {
                                if (selectedValues.contains(values[index])) {
                                  selectedValues.remove(values[index]);
                                } else {
                                  selectedValues.add(values[index]);
                                }
                              });
                            });
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
            ),
            errorLabel: "Не удалось загрузить столы")
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onSelected(selectedValues);
            Navigator.pop(context);
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
