import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../model/reservation.dart';

class ReservationViewModel extends ChangeNotifier {
  final List<Reservation> _reservations = [];

  UnmodifiableListView<Reservation> get reservations => UnmodifiableListView(_reservations);
  Reservation? get activeReservation => null;
  set activeReservation(Reservation? reservation) => activeReservation = reservation;

  void load() {
    // TODO: ADD HTTP REQUEST TO GET ALL RESERVATIONS
    _reservations.addAll([
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
    ]);
    notifyListeners();
  }

  void loadById(int reservationId) {
    // TODO: ADD HTTP REQUEST TO GET RESERVATIONS BY ID
    activeReservation = _reservations[reservationId - 1];
    notifyListeners();
  }

  void add(Reservation reservation) {
    // TODO: ADD HTTP REQUEST TO CREATE RESERVATION
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

  void update(Reservation reservation) {
    // TODO: ADD HTTP REQUEST TO UPDATE RESERVATION
    _reservations[reservation.id! - 1] = reservation;
  }

  void deleteById(int reservationId) {
    // TODO: ADD HTTP REQUEST TO DELETE RESERVATION
    _reservations.removeAt(reservationId - 1);
    notifyListeners();
  }
}