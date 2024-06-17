import 'package:flutter/material.dart';

import 'package:restobook_mobile_client/model/model.dart';

class TableListTile extends StatelessWidget {
  const TableListTile({super.key, required this.table});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    String? status;
    if (table.state == "BROKEN") {
      status = "Сломан";
    }

    return Material(
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text("${table.seatsNumber}"),
          ),
          title: Text("Стол ${table.number}"),
          subtitle: status != null ? Text(status) : null,
        ),
      ),
    );
  }
}
