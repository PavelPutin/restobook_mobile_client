import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:restobook_mobile_client/model/model.dart';

class ReservationViewModel extends ChangeNotifier {
  AbstractTableRepository tableRepository = GetIt.I<AbstractTableRepository>();
  AbstractReservationRepository reservationRepository = GetIt.I<AbstractReservationRepository>();

  List<Reservation> _reservations = [];
  Reservation? _activeReservation;
  final List<TableModel> _activeReservationTables = [];

  UnmodifiableListView<Reservation> get reservations => UnmodifiableListView(_reservations);
  Reservation? get activeReservation => _activeReservation;
  UnmodifiableListView<TableModel> get activeReservationTables => UnmodifiableListView(_activeReservationTables);
  set activeReservation(Reservation? reservation) => _activeReservation = reservation;

  Future<void> load() async {
    // TODO: ADD HTTP REQUEST TO GET ALL RESERVATIONS
    _reservations = await reservationRepository.getAll();
    notifyListeners();
  }

  Future<void> loadActiveReservation(int reservationId) async {
    // TODO: ADD HTTP REQUEST TO GET RESERVATIONS BY ID
    activeReservation = await reservationRepository.getById(reservationId);
    notifyListeners();
  }

  Future<void> loadActiveReservationTables() async {
    await Future.delayed(const Duration(seconds: 1));
    _activeReservationTables.clear();
    for (int id in activeReservation!.tableIds!) {
      _activeReservationTables.add(await tableRepository.getById(id));
    }
    notifyListeners();
  }

  Future<void> add(Reservation reservation) async {
    // TODO: ADD HTTP REQUEST TO CREATE RESERVATION
    await reservationRepository.create(reservation);
    notifyListeners();
  }

  Future<void> update(Reservation reservation) async {
    // TODO: ADD HTTP REQUEST TO UPDATE RESERVATION
    activeReservation = await reservationRepository.update(reservation);
    await loadActiveReservationTables();
    for (var t in activeReservationTables) {
      t.reservationIds ??= [];
      if (!t.reservationIds!.contains(activeReservation!.id!)) {
        t.reservationIds?.add(activeReservation!.id!);
        tableRepository.update(t);
      }
    }
    notifyListeners();
  }

  Future<void> delete(Reservation reservation) async {
    // TODO: ADD HTTP REQUEST TO DELETE RESERVATION
    await reservationRepository.delete(reservation);
    notifyListeners();
  }
}