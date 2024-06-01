import 'package:restobook_mobile_client/model/entities/table_model.dart';

abstract class AbstractTableRepository {
  Future<List<TableModel>> getAll(int restaurantId);
  Future<TableModel> getById(int restaurantId, int id);
  Future<TableModel> create(int restaurantId, TableModel table);
  Future<TableModel> update(int restaurantId, TableModel table);
  Future<void> delete(int restaurantId, TableModel table);
}