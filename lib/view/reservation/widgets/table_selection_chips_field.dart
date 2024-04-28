import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/view/reservation/widgets/table_selection_dialog.dart';

import '../../../model/entities/table_model.dart';
import '../../shared_widget/chips_input.dart';

class TableSelectionChipsField extends StatelessWidget {
  const TableSelectionChipsField(
      {super.key,
      required this.tables,
      required this.targetDateTime,
      required this.onDeleted,
      required this.onSelected});

  final List<TableModel> tables;
  final DateTime targetDateTime;
  final Function(TableModel value) onDeleted;
  final Function(List<TableModel> values) onSelected;

  @override
  Widget build(BuildContext context) {
    return ChipsInput(
      values: tables,
      chipBuilder: (context, table) {
        return TableInputChip(
            table: table,
            onDeleted: onDeleted,
            onSelected: (table) {});
      },
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return TableSelectionDialog(
                alreadySelectedTables: tables,
                targetDateTime: targetDateTime,
                onSelected: onSelected,
              );
            });
      },
      onChanged: (tables) {},
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      strutStyle: const StrutStyle(fontSize: 15),
    );
  }
}
