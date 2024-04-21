import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../model/reservation.dart';

class ReservationViewModel extends ChangeNotifier {
  List<Reservation> _reservations = [];
  Reservation? _activeReservation;

  UnmodifiableListView<Reservation> get reservations => UnmodifiableListView(_reservations);
  Reservation? get activeReservation => _activeReservation;
  set activeReservation(Reservation? reservation) => _activeReservation = reservation;

  Future<void> load() async {
    // TODO: ADD HTTP REQUEST TO GET ALL RESERVATIONS
    await Future.delayed(const Duration(seconds: 1));
    _reservations = [
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
    notifyListeners();
  }

  Future<void> loadById(int reservationId) async {
    // TODO: ADD HTTP REQUEST TO GET RESERVATIONS BY ID
    await Future.delayed(const Duration(seconds: 1));
    activeReservation = _reservations[reservationId - 1];
    notifyListeners();
  }

  Future<void> add(Reservation reservation) async {
    // TODO: ADD HTTP REQUEST TO CREATE RESERVATION
    await Future.delayed(const Duration(seconds: 1));
    int maxId = 0;
    for (var r in _reservations) {
      if (r.id! > maxId) {
        maxId = r.id!;
      }
    }
    reservation.id = maxId + 1;
    reservation.state = "NORMAL";
    _reservations.add(reservation);
    notifyListeners();
  }

  Future<void> update(Reservation reservation) async {
    // TODO: ADD HTTP REQUEST TO UPDATE RESERVATION
    await Future.delayed(const Duration(seconds: 1));
    _reservations[reservation.id! - 1] = reservation;
  }

  Future<void> deleteById(int reservationId) async {
    // TODO: ADD HTTP REQUEST TO DELETE RESERVATION
    await Future.delayed(const Duration(seconds: 1));
    _reservations.removeAt(reservationId - 1);
    notifyListeners();
  }
}