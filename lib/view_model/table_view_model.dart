import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../model/table_model.dart';

class TableViewModel extends ChangeNotifier {
  List<TableModel> _tables = [];
  int _tries = 0;

  UnmodifiableListView<TableModel> get tables => UnmodifiableListView(_tables);
  TableModel? get activeTable => null;
  set activeTable(TableModel? table) => activeTable = table;
  int get tries => _tries;
  set tries(int value) => tries = value;

  Future<void> load() async {
    // TODO: ADD HTTP REQUEST TO GET ALL TABLES
    await Future.delayed(const Duration(seconds: 2));
    _tables = [
      TableModel(1, 1, 2, "NORMAL", 1, []),
      TableModel(2, 2, 1, "BROKEN", 1, []),
    ];
    _tries++;
    if (tries % 10 == 0) {
      throw UnimplementedError("Error table loading");
    }
    notifyListeners();
  }

  Future<void> loadById(int tableId) async {
    // TODO: ADD HTTP REQUEST TO GET TABLE BY ID
    await Future.delayed(const Duration(seconds: 1));
    activeTable = _tables[tableId - 1];
    notifyListeners();
  }

  Future<void> add(TableModel table) async {
    // TODO: ADD HTTP REQUEST TO CREATE TABLE
    await Future.delayed(const Duration(seconds: 1));
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

  Future<void> update(TableModel table) async {
    // TODO: ADD HTTP REQUEST TO UPDATE TABLE
    await Future.delayed(const Duration(seconds: 1));
    _tables[table.id! - 1] = table;
  }

  Future<void> deleteById(int tableId) async {
    // TODO: ADD HTTP REQUEST TO DELETE TABLE
    await Future.delayed(const Duration(seconds: 1));
    _tables.removeAt(tableId - 1);
    notifyListeners();
  }
}