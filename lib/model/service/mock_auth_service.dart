import 'package:get_it/get_it.dart';
import 'package:restobook_mobile_client/model/entities/auth_entity.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/service/abstract_auth_service.dart';
import 'package:restobook_mobile_client/model/utils/utils.dart';

class MockAuthService extends AbstractAuthService {
  AbstractEmployeeRepository employeeRepository = GetIt.I<
      AbstractEmployeeRepository>();

  List<AuthEntity> authEntities = [];
  AuthEntity? authenticated;

  MockAuthService() {
    employeeRepository.getAll().then((employees) {
      for (var employee in employees) {
        String role = employee.login == "putin_p_a"
            ? "ROLE_ADMIN"
            : "ROLE_EMPLOYEE";
        authEntities.add(AuthEntity(employee, "qwerty", role));
      }
    });
  }

  @override
  Future<AuthEntity> changePassword(AuthEntity authEntity, String newPassword) {
    return ConnectionSimulator<AuthEntity>().connect(() {
      for (var ae in authEntities) {
        if (ae.employee.login == authEntity.employee.login && ae.password == authEntity.password) {
          ae.password = newPassword;
          ae.employee.changedPassword = true;
          return ae;
        }
      }
      throw Exception("Ошибка в логине или пароле");
    });
  }

  @override
  Future<AuthEntity> login(String username, String password) {
    return ConnectionSimulator<AuthEntity>().connect(() {
      for (var authEntity in authEntities) {
          if (authEntity.employee.login == username && authEntity.password == password) {
            authenticated = authEntity;
            return authEntity;
          }
      }
      throw Exception("Ошибка в логине или пароле");
    });
  }

  @override
  Future<AuthEntity> getMe() {
    return ConnectionSimulator<AuthEntity>().connect(() {
      return authenticated;
    });
  }
}