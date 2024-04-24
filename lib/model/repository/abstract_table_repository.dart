import 'package:restobook_mobile_client/model/entities/table_model.dart';

abstract class AbstractTableRepository {
  Future<List<TableModel>> getAll();
  Future<TableModel> getById(int id);
  Future<void> create(TableModel table);
  Future<void> update(TableModel table);
  Future<void> delete(TableModel table);
}