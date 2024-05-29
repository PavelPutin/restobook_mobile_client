import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/repository/mock_backend.dart';

import '../service/api_dio.dart';
import '../utils/utils.dart';

class HttpEmployeeRepository extends AbstractEmployeeRepository {
  final List<Employee> _employees = GetIt.I<MockBackend>().employee;
  final api = GetIt.I<Api>();
  final logger = GetIt.I<Logger>();

  @override
  Future<Employee> create(int restaurantId, Employee employee, String password) async {
    try {
      logger.t("Try create employee");
      logger.t("Employee data:\n${employee}");
      Map<String, dynamic> creationData = employee.toJson();
      creationData["password"] = password;
      creationData["role"] = "restobook_user";
      final response = await api.dio.post(
          "/restobook-api/restaurant/$restaurantId/employee",
        data: creationData
      );
      var isEmpty = (response.data ?? "").toString().isEmpty;
      logger.t("Response data is empty: $isEmpty");
      if (!isEmpty) {
        logger.t("Response data:\n${response.data.toString()}");
      }
      Employee created = Employee.fromJson(response.data);
      logger.t("Created employee\n$created");
      return created;
    } on DioException catch (e) {
      logger.e("Can't create employee", error: e);
      if (e.response != null) {
        logger.e("Response body", error: e.response!.data);
        // if (e.response!.data != null) {
        //   throw e.response!.data!;
        // }
      }

      rethrow;
    }
  }

  @override
  Future<void> delete(Employee employee) {
    return ConnectionSimulator<void>().connect(() => _employees.remove(employee));
  }

  @override
  Future<List<Employee>> getAll(int restaurantId) async {
    try {
      logger.t("Try get all employees");
      final response = await api.dio.get(
          "/restobook-api/restaurant/$restaurantId/employee");
      var isEmpty = (response.data ?? "").toString().isEmpty;
      logger.t("Response data is empty: $isEmpty");
      if (!isEmpty) {
        logger.t("Response data:\n${response.data.toString()}");
      }
      List<Employee> result = [];
      for (var e in response.data) {
        result.add(Employee.fromJson(e));
      }
      return result;
    } on DioException catch (e) {
      logger.e("Can't get all employees", error: e);
      rethrow;
    }
  }

  @override
  Future<Employee> getById(int restaurantId, int id) async {
    try {
      logger.t("Try get employee $id");
      final response = await api.dio.get("/restobook-api/restaurant/$restaurantId/employee/$id");
      var isEmpty = (response.data ?? "").toString().isEmpty;
      logger.t("Response data is empty: $isEmpty");
      if (!isEmpty) {
        logger.t("Response data:\n${response.data.toString()}");
      }
      Employee fetched = Employee.fromJson(response.data);
      logger.t("Fetched employee\n$fetched");
      return fetched;
    } on DioException catch (e) {
      logger.e("Can't find employee $id", error: e);
      rethrow;
    }
    // return ConnectionSimulator<Employee>().connect(() {
    //   for (var employee in _employees) {
    //     if (employee.id == id) {
    //       return employee;
    //     }
    //   }
    //   throw Exception("Сотрудник не найден");
    // });
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