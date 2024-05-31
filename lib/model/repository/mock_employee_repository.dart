import 'package:get_it/get_it.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/repository/mock_backend.dart';

import '../utils/utils.dart';

class MockEmployeeRepository extends AbstractEmployeeRepository {
  final List<Employee> _employees = GetIt.I<MockBackend>().employee;

  @override
  Future<Employee> create(int restaurantId, Employee employee, String password) {
    return ConnectionSimulator<Employee>().connect(() {
      int maxId = 0;
      for (var e in _employees) {
        if (e.id! > maxId) {
          maxId = e.id!;
        }
      }
      employee.id = maxId + 1;
      _employees.add(employee);
      return employee;
    });
  }

  @override
  Future<void> delete(int restaurantId, Employee employee) {
    return ConnectionSimulator<void>().connect(() => _employees.remove(employee));
  }

  @override
  Future<List<Employee>> getAll(int restaurantId) {
    return ConnectionSimulator<List<Employee>>().connect(() => _employees);
  }

  @override
  Future<Employee> getById(int restaurantId, int id) {
    return ConnectionSimulator<Employee>().connect(() {
      for (var employee in _employees) {
        if (employee.id == id) {
          return employee;
        }
      }
      throw Exception("Сотрудник не найден");
    });
  }

  @override
  Future<Employee> update(Employee employee) {
    return ConnectionSimulator<Employee>().connect(() {
      for (int i = 0; i < _employees.length; i++) {
        if (_employees[i].id == employee.id) {
          _employees[i] = employee;
          return employee;
        }
      }
      throw Exception("Сотрудник не найден");
    });
  }

}