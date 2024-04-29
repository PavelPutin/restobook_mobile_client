import 'package:get_it/get_it.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/repository/mock_backend.dart';

import '../utils/utils.dart';

class MockReservationsRepository extends AbstractReservationRepository {
  final List<Reservation> _reservations = GetIt.I<MockBackend>().reservations;

  @override
  Future<Reservation> create(Reservation reservation) async {
    return ConnectionSimulator<Reservation>().connect(() {
      int maxId = 0;
      for (var r in _reservations) {
        if (r.id! > maxId) {
          maxId = r.id!;
        }
      }
      reservation.id = maxId + 1;
      reservation.state = "WAITING";
      reservation.restaurantId = 1;
      _reservations.add(reservation);
      return reservation;
    });
  }

  @override
  Future<void> delete(Reservation reservation) {
    return ConnectionSimulator<void>().connect(() => _reservations.remove(reservation));
  }

  @override
  Future<List<Reservation>> getAll() {
    return ConnectionSimulator<List<Reservation>>().connect(() => _reservations);
  }

  @override
  Future<List<Reservation>> getByDateTime(DateTime dateTime) {
    return ConnectionSimulator<List<Reservation>>().connect(() {
      List<Reservation> result = [];
      for (var r in _reservations) {
        int diff = r.startDateTime.difference(dateTime).inMinutes;
        if (-r.durationIntervalMinutes <= diff && diff <= 60) {
          result.add(r);
        }
      }
      return result;
    });
  }

  @override
  Future<Reservation> getById(int id) {
    return ConnectionSimulator<Reservation>().connect(() {
      for (var reservation in _reservations) {
        if (reservation.id == id) {
          return reservation;
        }
      }
      throw Exception("Бронь не найдена");
    });
  }

  @override
  Future<Reservation> update(Reservation reservation) {
    return ConnectionSimulator<Reservation>().connect(() {
      for (int i = 0; i < _reservations.length; i++) {
        if (_reservations[i].id == reservation.id) {
          _reservations[i] = reservation;
          return reservation;
        }
      }
      throw Exception("Бронь не найдена");
    });
  }
}