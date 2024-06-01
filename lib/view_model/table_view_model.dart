import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:restobook_mobile_client/model/model.dart';

import 'application_view_model.dart';

class TableViewModel extends ChangeNotifier {
  AbstractTableRepository tableRepository = GetIt.I<AbstractTableRepository>();
  AbstractReservationRepository reservationRepository = GetIt.I<
      AbstractReservationRepository>();

  List<TableModel> _tables = [];
  final List<Reservation> _activeTableReservations = [];
  TableModel? _activeTable;

  UnmodifiableListView<TableModel> get tables => UnmodifiableListView(_tables);

  TableModel? get activeTable => _activeTable;

  set activeTable(TableModel? table) => _activeTable = table;

  UnmodifiableListView<Reservation> get activeTableReservations =>
      UnmodifiableListView(_activeTableReservations);

  Future<void> load(int restaurantId) async {
    // TODO: ADD HTTP REQUEST TO GET ALL TABLES
    _tables = await tableRepository.getAll(restaurantId);
    notifyListeners();
  }

  Future<void> loadWithDateTime(int restaurantId, DateTime dateTime) async {
    _tables = await tableRepository.getAll(restaurantId);
    var reservations = await reservationRepository.getByDateTime(restaurantId, dateTime);
    for (var t in _tables) {
      t.reservedState = "FREE";
      for (var r in reservations) {
        if (r.tableIds == null) {
          continue;
        }
        for (var tId in r.tableIds!) {
          if (t.id! == tId) {
            if (r.state! == "OPEN") {
              t.reservedState = "RESERVED";
            } else if (r.state! == "WAITING") {
              t.reservedState = "NEAR_RESERVED";
            }
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> loadActiveTable(int restaurantId, int tableId) async {
    // TODO: ADD HTTP REQUEST TO GET TABLE BY ID
    activeTable = await tableRepository.getById(restaurantId, tableId);
    notifyListeners();
  }

  Future<void> loadActiveTableReservations(int restaurantId) async {
    // TODO: ADD HTTP REQUEST TO GET RESERVATIONS BY ID
    _activeTableReservations.clear();
    if (activeTable!.reservationIds != null) {
      for (int id in activeTable!.reservationIds!) {
        _activeTableReservations.add(await reservationRepository.getById(restaurantId, id));
      }
    }
    notifyListeners();
  }

  Future<void> add(int restaurantId, TableModel table) async {
    // TODO: ADD HTTP REQUEST TO CREATE TABLE
    activeTable = await tableRepository.create(restaurantId, table);
    notifyListeners();
  }

  Future<void> update(TableModel table) async {
    // TODO: ADD HTTP REQUEST TO UPDATE TABLE
    activeTable = await tableRepository.update(table);
    notifyListeners();
  }

  Future<void> delete(TableModel table) async {
    // TODO: ADD HTTP REQUEST TO DELETE TABLE
    await tableRepository.delete(table);
    notifyListeners();
  }
}