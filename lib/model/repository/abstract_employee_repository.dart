import 'package:restobook_mobile_client/model/model.dart';

abstract class AbstractEmployeeRepository {
  Future<List<Employee>> getAll(int restaurantId);
  Future<Employee> getById(int id);
  Future<Employee> create(Employee employee);
  Future<Employee> update(Employee employee);
  Future<void> delete(Employee employee);
}