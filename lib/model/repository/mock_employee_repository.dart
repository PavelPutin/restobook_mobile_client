import 'package:restobook_mobile_client/model/model.dart';

import '../utils/utils.dart';

class MockEmployeeRepository extends AbstractEmployeeRepository {
  final List<Employee> _employees = List.from([
    Employee(
        1,
        "frolov_m_vR1",
        "Фролов",
        "Макар",
        null,
        "Лучший сотрудник!",
        true,
        1
    ),
    Employee(
        2,
        "pupkin_v_pR1",
        "Пупкин",
        "Василий",
        "Петрович",
        "стажёр",
        false,
        1
    ),
    Employee(
        3,
        "putin_p_a",
        "Путин",
        "Павел",
        "Александрович",
        "администратор",
        false,
        1
    )
  ]);

  @override
  Future<Employee> create(Employee employee) {
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
  Future<void> delete(Employee employee) {
    return ConnectionSimulator<void>().connect(() => _employees.remove(employee));
  }

  @override
  Future<List<Employee>> getAll() {
    return ConnectionSimulator<List<Employee>>().connect(() => _employees);
  }

  @override
  Future<Employee> getById(int id) {
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