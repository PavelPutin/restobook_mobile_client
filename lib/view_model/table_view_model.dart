import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../model/reservation.dart';
import '../model/table_model.dart';

class TableViewModel extends ChangeNotifier {
  List<TableModel> _tables = [];
  final List<Reservation> _activeTableReservations = [];
  TableModel? _activeTable;
  int _tries = 0;

  UnmodifiableListView<TableModel> get tables => UnmodifiableListView(_tables);
  TableModel? get activeTable => _activeTable;
  set activeTable(TableModel? table) => _activeTable = table;

  UnmodifiableListView<Reservation> get activeTableReservations => UnmodifiableListView(_activeTableReservations);

  int get tries => _tries;
  set tries(int value) => _tries = value;

  Future<void> load() async {
    // TODO: ADD HTTP REQUEST TO GET ALL TABLES
    await Future.delayed(const Duration(seconds: 2));
    _tables = [
      TableModel(1, 1, 2, "NORMAL", 1, List.from([1])),
      TableModel(2, 2, 1, "BROKEN", 1, List.from([1, 2])),
    ];
    _tries++;
    if (tries % 2 == 0) {
      throw UnimplementedError("Error table loading");
    }
    notifyListeners();
  }

  Future<void> loadById(int tableId) async {
    // TODO: ADD HTTP REQUEST TO GET TABLE BY ID
    await Future.delayed(const Duration(seconds: 2));
    activeTable = _tables[tableId - 1];
    notifyListeners();
  }

  Future<void> loadActiveTableReservations() async {
    // TODO: ADD HTTP REQUEST TO GET RESERVATIONS BY ID
    await Future.delayed(const Duration(seconds: 2));
    List<Reservation> reservations = [
      Reservation(
          1,
          2,
          "+79007629931",
          "Василий",
          DateTime.utc(2024, 4, 19, 19, 00, 00),
          60,
          "Фролов Макар Викторович",
          DateTime.utc(2024, 4, 19, 17, 54, 32),
          "WAITING",
          "Юбилей",
          1,
          [1]
      ),
      Reservation(
          2,
          3,
          "+79217629932",
          "Анатолий",
          DateTime.utc(2024, 4, 20, 17, 00, 00),
          60,
          "Фролов Макар Викторович",
          DateTime.utc(2024, 4, 19, 18, 17, 32),
          "WAITING",
          null,
          1,
          [1, 2]
      ),
    ];

    _activeTableReservations.clear();
    for (int id in activeTable!.reservationIds!) {
      _activeTableReservations.add(reservations[id - 1]);
    }
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