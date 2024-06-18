import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:restobook_mobile_client/model/model.dart';

class TableViewModel extends ChangeNotifier {
  AbstractTableRepository tableRepository = GetIt.I<AbstractTableRepository>();
  AbstractReservationRepository reservationRepository = GetIt.I<
      AbstractReservationRepository>();

  DateTime _date = DateTime.now();
  DateTime get date => _date;
  set date(value) => _date = value;

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay get time => _time;
  set time(value) => _time = value;

  List<TableModel> _tables = [];
  final List<Reservation> _activeTableReservations = [];
  TableModel? _activeTable;

  UnmodifiableListView<TableModel> get tables => UnmodifiableListView(_tables);

  TableModel? get activeTable => _activeTable;

  set activeTable(TableModel? table) => _activeTable = table;

  UnmodifiableListView<Reservation> get activeTableReservations =>
      UnmodifiableListView(_activeTableReservations);

  Future<void> load(int restaurantId) async {
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
    activeTable = await tableRepository.getById(restaurantId, tableId);
    notifyListeners();
  }

  Future<void> loadActiveTableReservations(int restaurantId) async {
    _activeTableReservations.clear();
    if (activeTable!.reservationIds != null) {
      await loadActiveTable(restaurantId, activeTable!.id!);
      for (int id in activeTable!.reservationIds!) {
        _activeTableReservations.add(await reservationRepository.getById(restaurantId, id));
      }
    }
    notifyListeners();
  }

  Future<void> add(int restaurantId, TableModel table) async {
    activeTable = await tableRepository.create(restaurantId, table);
    final selectedTime = DateTime.utc(
        _date.year, _date.month, _date.day, _time.hour, _time.minute);
    loadWithDateTime(restaurantId, selectedTime);
    notifyListeners();
  }

  Future<void> update(int restaurantId, TableModel table) async {
    activeTable = await tableRepository.update(restaurantId, table);
    final selectedTime = DateTime.utc(
        _date.year, _date.month, _date.day, _time.hour, _time.minute);
    loadWithDateTime(restaurantId, selectedTime);
    notifyListeners();
  }

  Future<void> delete(int restaurantId, TableModel table) async {
    await tableRepository.delete(restaurantId, table);
    final selectedTime = DateTime.utc(
        _date.year, _date.month, _date.day, _time.hour, _time.minute);
    loadWithDateTime(restaurantId, selectedTime);
    notifyListeners();
  }
}