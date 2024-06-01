import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/repository/mock_backend.dart';

import '../service/api_dio.dart';
import '../utils/utils.dart';

class HttpReservationsRepository extends AbstractReservationRepository {
  final List<TableModel> _tables = GetIt.I<MockBackend>().tables;
  final List<Reservation> _reservations = GetIt.I<MockBackend>().reservations;

  final api = GetIt.I<Api>();
  final logger = GetIt.I<Logger>();

  @override
  Future<Reservation> create(int restaurantId, Reservation reservation) async {
    try {
      logger.t("Try to create reservation");
      final response = await api.dio.post(
          "/restobook-api/restaurant/$restaurantId/reservation",
        data: reservation
      );

      var isEmpty = (response.data ?? "").toString().isEmpty;
      logger.t("Response data is empty: $isEmpty");
      if (!isEmpty) {
        logger.t("Response data:\n${response.data.toString()}");
      }
      Reservation created = Reservation.fromJson(response.data);
      logger.t("Created reservation\n$created");
      return created;
    } on DioException catch (e) {
      logger.e("Can't create reservation", error: e);
      rethrow;
    }
  }

  @override
  Future<void> delete(Reservation reservation) {
    for (int tableId in reservation.tableIds!) {
      for (var table in _tables) {
        if (table.id! == tableId) {
          table.reservationIds!.remove(reservation.id!);
        }
      }
    }
    return ConnectionSimulator<void>().connect(() => _reservations.remove(reservation));
  }

  @override
  Future<List<Reservation>> getAll(int restaurantId) async {
    // _reservations.sort(comparator);
    // return ConnectionSimulator<List<Reservation>>().connect(() => _reservations);
    try {
      logger.t("Try get all reservations");
      final response = await api.dio.get("/restobook-api/restaurant/$restaurantId/reservation");
      List<Reservation> result = [];
      for (var e in response.data) {
        result.add(Reservation.fromJson(e));
      }
      logger.t("Get all reservations");
      return result;
    } on DioException catch (e) {
      logger.e("Can't get all reservations", error: e);
      rethrow;
    }
  }

  @override
  Future<List<Reservation>> getByDateTime(DateTime dateTime) {
    _reservations.sort(comparator);
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
          for (int tId in _reservations[i].tableIds!) {
            for (var t in _tables) {
              if (t.id! == tId && !reservation.tableIds!.contains(tId)) {
                t.reservationIds!.remove(_reservations[i].id!);
              }
            }
          }
          _reservations[i] = reservation;

          _reservations.sort(comparator);
          return reservation;
        }
      }
      throw Exception("Бронь не найдена");
    });
  }

  int comparator(Reservation a, Reservation b) {
    if (a.state == "CLOSED" && b.state != "CLOSED") return 1;
    if (a.state == "WAITING" && b.state == "CLOSED") return -1;
    if (a.state == "WAITING" && b.state == "OPEN") return 1;
    if (a.state == "OPEN" && b.state != "OPEN") return -1;
    if (a.startDateTime.isBefore(b.startDateTime)) return 1;
    return a.id! < b.id! ? 1 : -1;
  }
}