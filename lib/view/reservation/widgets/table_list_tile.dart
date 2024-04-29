import 'package:flutter/material.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../table/screens/table_screen.dart';

class TableListTile extends StatelessWidget {
  const TableListTile({super.key, required this.table});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    var status = switch (table.reservedState) {
      "FREE" => "Свободен",
      "NEAR_RESERVED" => "Бронь в течение часа",
      "RESERVED" => "Занят",
    // TODO: Handle this case.
      String() => throw UnimplementedError(),
    };

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
          subtitle: Text(status),
        ),
      ),
    );
  }
}
