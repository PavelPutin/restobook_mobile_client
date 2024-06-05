import 'package:flutter/material.dart';

import '../../../model/entities/table_model.dart';

class TableSelectionTile extends StatefulWidget {
  const TableSelectionTile(
      {super.key, required this.table , required this.title, required this.onTap});

  final TableModel table;
  final Widget title;
  final Function() onTap;

  @override
  State<TableSelectionTile> createState() => _TableSelectionTileState();
}

class _TableSelectionTileState extends State<TableSelectionTile> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    var color = switch (widget.table.reservedState) {
      "FREE" => Colors.greenAccent,
      "NEAR_RESERVED" => Colors.amberAccent,
      "RESERVED" => Colors.redAccent,
    // TODO: Handle this case.
      String() => throw UnimplementedError(),
    };
    if (widget.table.state == "BROKEN") {
      color = Colors.redAccent;
    }

    return InkWell(
      child: Ink(
        child: ListTile(
          tileColor: color,
          leading: !selected
              ? const Icon(Icons.circle_outlined)
              : const Icon(Icons.check_circle_outline),
          title: widget.title,
          onTap: () {
            setState(() {
              selected = !selected;
            });
            widget.onTap();
          },
        ),
      ),
    );
  }
}