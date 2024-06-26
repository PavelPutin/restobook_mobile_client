import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/view/main_screen/widgets/tables_list.dart';

class EmployeeViewModel extends ChangeNotifier {
  AbstractEmployeeRepository employeeRepository = GetIt.I<AbstractEmployeeRepository>();

  List<Employee> _employees = [];
  Employee? _activeEmployee;

  UnmodifiableListView<Employee> get employees => UnmodifiableListView(_employees);
  Employee? get activeEmployee => _activeEmployee;
  set activeEmployee(Employee? employee) => _activeEmployee = employee;

  Future<void> load(int restaurantId) async {
    _employees = await employeeRepository.getAll(restaurantId);
    notifyListeners();
  }

  Future<void> loadActiveEmployee(int restaurantId, int employeeId) async {
    activeEmployee = await employeeRepository.getById(restaurantId, employeeId);
    notifyListeners();
  }

  Future<void> add(int restaurantId, Employee employee, String password) async {
    logger.t("Employee view model employee creation");
    activeEmployee = await employeeRepository.create(restaurantId, employee, password);
    logger.t("New active employee:\n${activeEmployee?.toJson()}");
    load(restaurantId);
    notifyListeners();
  }

  Future<void> update(int restaurantId, Employee employee) async {
    activeEmployee = await employeeRepository.update(restaurantId, employee);
    load(restaurantId);
    notifyListeners();
  }

  Future<void> delete(int restaurantId, Employee employee) async {
    await employeeRepository.delete(restaurantId, employee);
    load(restaurantId);
    notifyListeners();
  }
}