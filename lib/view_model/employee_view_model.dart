import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:restobook_mobile_client/model/employee.dart';

class EmployeeViewModel extends ChangeNotifier {
  final List<Employee> _employees = [];

  UnmodifiableListView<Employee> get reservations => UnmodifiableListView(_employees);
  Employee? get activeEmployee => null;
  set activeEmployee(Employee? employee) => activeEmployee = employee;

  Future<void> load() async {
    // TODO: ADD HTTP REQUEST TO GET ALL EMPLOYEES
    await Future.delayed(const Duration(seconds: 1));
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

  Future<void> loadById(int reservationId) async {
    // TODO: ADD HTTP REQUEST TO GET EMPLOYEES BY ID
    await Future.delayed(const Duration(seconds: 1));
    activeEmployee = _employees[reservationId - 1];
    notifyListeners();
  }

  Future<void> add(Employee employee) async {
    // TODO: ADD HTTP REQUEST TO CREATE EMPLOYEE
    await Future.delayed(const Duration(seconds: 1));
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

  Future<void> update(Employee employee) async {
    // TODO: ADD HTTP REQUEST TO UPDATE EMPLOYEE
    await Future.delayed(const Duration(seconds: 1));
    _employees[employee.id! - 1] = employee;
  }

  Future<void> deleteById(int employeeId) async {
    // TODO: ADD HTTP REQUEST TO DELETE EMPLOYEE
    await Future.delayed(const Duration(seconds: 1));
    _employees.removeAt(employeeId - 1);
    notifyListeners();
  }
}