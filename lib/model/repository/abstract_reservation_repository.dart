import 'package:restobook_mobile_client/model/model.dart';

abstract class AbstractReservationRepository {
  Future<List<Reservation>> getAll();
  Future<Reservation> getById(int id);
  Future<void> create(Reservation reservation);
  Future<void> update(Reservation reservation);
  Future<void> delete(Reservation reservation);
}