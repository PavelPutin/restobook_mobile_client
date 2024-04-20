import 'package:flutter/material.dart';

import '../../model/table_model.dart';


class TableListTile extends StatelessWidget {
  const TableListTile({super.key, required this.table});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Стол ${table.number}")
    );
  }

}