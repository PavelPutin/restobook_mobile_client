import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:restobook_mobile_client/model/employee.dart';

class EmployeeViewModel extends ChangeNotifier {
  final List<Employee> _employees = [];

  UnmodifiableListView<Employee> get reservations => UnmodifiableListView(_employees);
  Employee? get activeEmployee => null;
  set activeEmployee(Employee? employee) => activeEmployee = employee;

  void load() {
    // TODO: ADD HTTP REQUEST TO GET ALL EMPLOYEES
    _employees.addAll([
      Employee(
        1,
        "frolov_m_vR1",
        "Фролов",
        "Макар",
        "Викторович",
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
      )
    ]);
    notifyListeners();
  }

  void loadById(int reservationId) {
    // TODO: ADD HTTP REQUEST TO GET EMPLOYEES BY ID
    activeEmployee = _employees[reservationId - 1];
    notifyListeners();
  }

  void add(Employee employee) {
    // TODO: ADD HTTP REQUEST TO CREATE EMPLOYEE
    int maxId = 0;
    for (var e in _employees) {
      if (e.id! > maxId) {
        maxId = e.id!;
      }
    }
    employee.id = maxId + 1;
    _employees.add(employee);
    notifyListeners();
  }

  void update(Employee employee) {
    // TODO: ADD HTTP REQUEST TO UPDATE EMPLOYEE
    _employees[employee.id! - 1] = employee;
  }

  void deleteById(int employeeId) {
    // TODO: ADD HTTP REQUEST TO DELETE EMPLOYEE
    _employees.removeAt(employeeId - 1);
    notifyListeners();
  }
}