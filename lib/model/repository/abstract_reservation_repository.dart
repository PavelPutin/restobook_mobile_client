import 'package:restobook_mobile_client/model/model.dart';

abstract class AbstractReservationRepository {
  Future<List<Reservation>> getAll(int restaurantId);
  Future<List<Reservation>> getByDateTime(int restaurantId, DateTime dateTime);
  Future<Reservation> getById(int restaurantId, int id);
  Future<Reservation> create(int restaurantId, Reservation reservation);
  Future<Reservation> update(Reservation reservation);
  Future<void> delete(Reservation reservation);
}