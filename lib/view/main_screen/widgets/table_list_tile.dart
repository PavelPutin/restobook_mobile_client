import 'package:flutter/material.dart';

import '../../../model/table_model.dart';
import '../../table_screen.dart';


class TableListTile extends StatelessWidget {
  const TableListTile({super.key, required this.table});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text("Стол ${table.number}"),
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