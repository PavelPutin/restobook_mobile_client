import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:restobook_mobile_client/model/model.dart';

class ReservationViewModel extends ChangeNotifier {
  AbstractTableRepository tableRepository = GetIt.I<AbstractTableRepository>();
  AbstractReservationRepository reservationRepository =
      GetIt.I<AbstractReservationRepository>();

  List<Reservation> _reservations = [];
  Reservation? _activeReservation;
  final List<TableModel> _activeReservationTables = [];

  UnmodifiableListView<Reservation> get reservations =>
      UnmodifiableListView(_reservations);

  Reservation? get activeReservation => _activeReservation;

  UnmodifiableListView<TableModel> get activeReservationTables =>
      UnmodifiableListView(_activeReservationTables);

  set activeReservation(Reservation? reservation) =>
      _activeReservation = reservation;

  Future<void> load(int restaurantId) async {
    // TODO: ADD HTTP REQUEST TO GET ALL RESERVATIONS
    _reservations = await reservationRepository.getAll(restaurantId);
    notifyListeners();
  }

  Future<void> loadActiveReservation(int restaurantId, int reservationId) async {
    // TODO: ADD HTTP REQUEST TO GET RESERVATIONS BY ID
    activeReservation = await reservationRepository.getById(restaurantId, reservationId);
    notifyListeners();
  }

  Future<void> loadActiveReservationTables(int restaurantId) async {
    await Future.delayed(const Duration(seconds: 1));
    _activeReservationTables.clear();
    for (int id in activeReservation!.tableIds!) {
      _activeReservationTables.add(await tableRepository.getById(restaurantId, id));
    }
    notifyListeners();
  }

  Future<void> add(int restaurantId, Reservation reservation, List<TableModel> tables) async {
    // TODO: ADD HTTP REQUEST TO CREATE RESERVATION
    var creating = reservationRepository.create(restaurantId, reservation);
    await creating.then((value) {
      activeReservation = value;
      for (var t in tables) {
        t.reservationIds ??= [];
        t.reservationIds!.add(activeReservation!.id!);
        tableRepository.update(restaurantId, t);
      }
    });
    load(restaurantId);
    notifyListeners();
  }

  Future<void> update(int restaurantId, Reservation reservation) async {
    // TODO: ADD HTTP REQUEST TO UPDATE RESERVATION
    activeReservation = await reservationRepository.update(restaurantId, reservation);
    await loadActiveReservationTables(restaurantId);
    for (var t in activeReservationTables) {
      t.reservationIds ??= [];
      if (!t.reservationIds!.contains(activeReservation!.id!)) {
        t.reservationIds?.add(activeReservation!.id!);
        tableRepository.update(restaurantId, t);
      }
    }
    load(restaurantId);
    notifyListeners();
  }

  Future<void> delete(int restaurantId, Reservation reservation) async {
    // TODO: ADD HTTP REQUEST TO DELETE RESERVATION
    await reservationRepository.delete(restaurantId, reservation);
    load(restaurantId);
    notifyListeners();
  }
}
