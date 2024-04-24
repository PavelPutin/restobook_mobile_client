import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:restobook_mobile_client/model/model.dart';

class TableViewModel extends ChangeNotifier {
  AbstractTableRepository tableRepository = GetIt.I<AbstractTableRepository>();
  AbstractReservationRepository reservationRepository = GetIt.I<AbstractReservationRepository>();

  List<TableModel> _tables = [];
  final List<Reservation> _activeTableReservations = [];
  TableModel? _activeTable;

  UnmodifiableListView<TableModel> get tables => UnmodifiableListView(_tables);
  TableModel? get activeTable => _activeTable;
  set activeTable(TableModel? table) => _activeTable = table;

  UnmodifiableListView<Reservation> get activeTableReservations => UnmodifiableListView(_activeTableReservations);

  Future<void> load() async {
    // TODO: ADD HTTP REQUEST TO GET ALL TABLES
    _tables = await tableRepository.getAll();
    notifyListeners();
  }

  Future<void> loadActiveTable(int tableId) async {
    // TODO: ADD HTTP REQUEST TO GET TABLE BY ID
    activeTable = await tableRepository.getById(tableId);
    notifyListeners();
  }

  Future<void> loadActiveTableReservations() async {
    // TODO: ADD HTTP REQUEST TO GET RESERVATIONS BY ID
    _activeTableReservations.clear();
    for (int id in activeTable!.reservationIds!) {
      _activeTableReservations.add(await reservationRepository.getById(id));
    }
    notifyListeners();
  }

  Future<void> add(TableModel table) async {
    // TODO: ADD HTTP REQUEST TO CREATE TABLE
    activeTable = await tableRepository.create(table);
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