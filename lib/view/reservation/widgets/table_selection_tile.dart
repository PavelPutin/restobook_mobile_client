import 'package:flutter/material.dart';

class TableSelectionTile extends StatefulWidget {
  const TableSelectionTile(
      {super.key, required this.title, required this.onTap});

  final Widget title;
  final Function() onTap;

  @override
  State<TableSelectionTile> createState() => _TableSelectionTileState();
}

class _TableSelectionTileState extends State<TableSelectionTile> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Ink(
        child: ListTile(
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