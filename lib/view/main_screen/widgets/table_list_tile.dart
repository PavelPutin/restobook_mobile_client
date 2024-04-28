import 'package:flutter/material.dart';

import 'package:restobook_mobile_client/model/model.dart';
import '../../table/screens/table_screen.dart';

class TableListTile extends StatelessWidget {
  const TableListTile({super.key, required this.table});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    var color = switch (table.reservedState) {
      "FREE" => Colors.greenAccent,
      "NEAR_RESERVED" => Colors.amberAccent,
      "RESERVED" => Colors.redAccent,
      // TODO: Handle this case.
      String() => throw UnimplementedError(),
    };
    if (table.state == "BROKEN") {
      color = Colors.redAccent;
    }

    var status = switch (table.reservedState) {
      "FREE" => "Свободен",
      "NEAR_RESERVED" => "Бронь в течение часа",
      "RESERVED" => "Занят",
    // TODO: Handle this case.
      String() => throw UnimplementedError(),
    };

    return Material(
      child: Card(
        color: color,
        child: ListTile(
          title: Text("Стол ${table.number}"),
          subtitle: Text(status),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TableScreen(table: table)));
          },
        ),
      ),
    );
  }
}
