import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:restobook_mobile_client/model/model.dart';

class EmployeeViewModel extends ChangeNotifier {
  AbstractEmployeeRepository employeeRepository = GetIt.I<AbstractEmployeeRepository>();

  List<Employee> _employees = [];
  Employee? _activeEmployee;

  UnmodifiableListView<Employee> get employees => UnmodifiableListView(_employees);
  Employee? get activeEmployee => _activeEmployee;
  set activeEmployee(Employee? employee) => _activeEmployee = employee;

  Future<void> load() async {
    // TODO: ADD HTTP REQUEST TO GET ALL EMPLOYEES
    _employees = await employeeRepository.getAll();
    notifyListeners();
  }

  Future<void> loadActiveEmployee(int employeeId) async {
    // TODO: ADD HTTP REQUEST TO GET EMPLOYEES BY ID
    activeEmployee = await employeeRepository.getById(employeeId);
    notifyListeners();
  }

  Future<void> add(Employee employee) async {
    // TODO: ADD HTTP REQUEST TO CREATE EMPLOYEE
    activeEmployee = await employeeRepository.create(employee);
    notifyListeners();
  }

  Future<void> update(Employee employee) async {
    // TODO: ADD HTTP REQUEST TO UPDATE EMPLOYEE
    activeEmployee = await employeeRepository.update(employee);
    notifyListeners();
  }

  Future<void> deleteById(Employee employee) async {
    // TODO: ADD HTTP REQUEST TO DELETE EMPLOYEE
    await employeeRepository.delete(employee);
    notifyListeners();
  }
}