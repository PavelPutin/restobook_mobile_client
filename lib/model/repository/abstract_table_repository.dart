import 'package:restobook_mobile_client/model/entities/table_model.dart';

abstract class AbstractTableRepository {
  Future<List<TableModel>> getAll(int restaurantId);
  Future<TableModel> getById(int id);
  Future<TableModel> create(int restaurantId, TableModel table);
  Future<TableModel> update(TableModel table);
  Future<void> delete(TableModel table);
}