import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:restobook_mobile_client/model/entities/auth_entity.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/service/abstract_auth_service.dart';
import 'package:restobook_mobile_client/model/service/api_dio.dart';
import 'package:restobook_mobile_client/model/utils/utils.dart';

class HttpAuthService extends AbstractAuthService {
  AbstractEmployeeRepository employeeRepository = GetIt.I
    <AbstractEmployeeRepository>();
  Api api = GetIt.I<Api>();

  @override
  Future<AuthEntity?> changePassword(AuthEntity authEntity, String newPassword) {
    return ConnectionSimulator<AuthEntity>().connect(() {

    });
  }

  @override
  Future<AuthEntity?> login(String username, String password) {
    return ConnectionSimulator<AuthEntity>().connect(() {});
  }

  @override
  Future<AuthEntity?> getMe() async {
    var response = await api.dio.get("/restobook-api/auth/me");
    print(response);
    if (response.statusCode == 200) {
      print(response.data.toString());
      Employee employee = Employee.fromJson(response.data);
      final role = response.data['role'];
      var authEntity = AuthEntity(employee, "", role);
      return authEntity;
    }
    throw "Not authorized";
  }
}