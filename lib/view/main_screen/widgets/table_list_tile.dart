import 'package:flutter/material.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../table/screens/table_screen.dart';


class TableListTile extends StatelessWidget {
  const TableListTile({super.key, required this.table});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text("Стол ${table.number} + ${table.reservedState}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TableScreen(table: table))
          );
        },
      ),
    );
  }

}