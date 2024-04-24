import 'package:restobook_mobile_client/model/model.dart';

abstract class AbstractEmployeeRepository {
  Future<List<Employee>> getAll();
  Future<Employee> getById(int id);
  Future<void> create(Employee employee);
  Future<void> update(Employee employee);
  Future<void> delete(Employee employee);
}