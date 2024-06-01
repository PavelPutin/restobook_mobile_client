import 'package:restobook_mobile_client/model/model.dart';

abstract class AbstractReservationRepository {
  Future<List<Reservation>> getAll();
  Future<List<Reservation>> getByDateTime(DateTime dateTime);
  Future<Reservation> getById(int id);
  Future<Reservation> create(int restaurantId, Reservation reservation);
  Future<Reservation> update(Reservation reservation);
  Future<void> delete(Reservation reservation);
}