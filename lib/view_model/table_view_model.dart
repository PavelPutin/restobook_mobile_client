import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../model/table.dart';

class TableViewModel extends ChangeNotifier {
  final List<Table> _tables = [];

  UnmodifiableListView<Table> get tables => UnmodifiableListView(_tables);
  Table? get activeTable => null;
  set activeTable(Table? table) => activeTable = table;

  void load() {
    // TODO: ADD HTTP REQUEST TO GET ALL TABLES
    _tables.addAll([
      Table(1, 1, 2, "NORMAL", 1, []),
      Table(2, 2, 1, "BROKEN", 1, []),
    ]);
    notifyListeners();
  }

  void loadById(int tableId) {
    // TODO: ADD HTTP REQUEST TO GET TABLE BY ID
    activeTable = _tables[tableId - 1];
    notifyListeners();
  }

  void add(Table table) {
    // TODO: ADD HTTP REQUEST TO CREATE TABLE
    int maxId = 0;
    for (var t in _tables) {
      if (t.id! > maxId) {
        maxId = t.id!;
      }
    }
    table.id = maxId + 1;
    table.state = "NORMAL";
    _tables.add(table);
    notifyListeners();
  }

  void update(Table table) {
    // TODO: ADD HTTP REQUEST TO UPDATE TABLE
    _tables[table.id! - 1] = table;
  }

  void deleteById(int tableId) {
    // TODO: ADD HTTP REQUEST TO DELETE TABLE
    _tables.removeAt(tableId - 1);
    notifyListeners();
  }
}