import 'package:restobook_mobile_client/model/model.dart';

abstract class AbstractEmployeeRepository {
  Future<List<Employee>> getAll(int restaurantId);
  Future<Employee> getById(int restaurantId, int id);
  Future<Employee> create(int restaurantId, Employee employee, String password);
  Future<Employee> update(Employee employee);
  Future<void> delete(Employee employee);
}