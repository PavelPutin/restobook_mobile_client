import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_mobile_client/model/entities/auth_entity.dart';
import 'package:restobook_mobile_client/model/model.dart';
import 'package:restobook_mobile_client/model/service/abstract_auth_service.dart';
import 'package:restobook_mobile_client/model/service/api_dio.dart';
import 'package:restobook_mobile_client/model/utils/utils.dart';
import 'package:dio/dio.dart' as dio;

class HttpAuthService extends AbstractAuthService {
  AbstractEmployeeRepository employeeRepository = GetIt.I
    <AbstractEmployeeRepository>();
  Api api = GetIt.I<Api>();
  Logger logger = GetIt.I<Logger>();

  @override
  Future<AuthEntity?> changePassword(AuthEntity authEntity, String newPassword) {
    return ConnectionSimulator<AuthEntity>().connect(() {

    });
  }

  @override
  Future<AuthEntity?> login(String username, String password) async {
    logger.t("Try login for $username $password");
    try {
      var response = await api.dio.post(
          "/realms/restaurant/protocol/openid-connect/token",
          data: {
            "grant_type": "password",
            "client_id": Api.clientId,
            "username": username,
            "password": password,
            "client_secret": Api.clientSecret
          },
          options: dio.Options(
              contentType: dio.Headers.formUrlEncodedContentType)
      );

      logger.t("Response status is ${response.statusCode}");
      logger.t("Response data");
      logger.t(response.data);

      if (response.statusCode! == 200) {
        var accessToken = response.data["access_token"];
        logger.t("Get accessToken");
        await api.secureStorage.write(
            key: Api.accessTokenKey, value: accessToken);
        logger.t("Save accessToken");
        var refreshToken = response.data["refresh_token"];
        logger.t("Get refreshToken");
        await api.secureStorage.write(
            key: Api.refreshTokenKey, value: refreshToken);
        logger.t("Save refreshToken");
        return await getMe();
      }
    } on dio.DioException catch (e) {
      logger.e("Catch DioException", error: e);
      rethrow;
    }
  }

  @override
  Future<AuthEntity?> getMe() async {
    logger.t("Try get authed user data");

    try {
      var response = await api.dio.get("/restobook-api/auth/me");

      logger.t("Response status is ${response.statusCode}");
      logger.t("Response data");
      logger.t(response.data);

      if (response.statusCode == 200) {
        Employee employee = Employee.fromJson(response.data);
        logger.t("Employee\n$employee");
        final role = response.data['role'];
        logger.t("Role\n$role");
        var authEntity = AuthEntity(employee, "", role);
        return authEntity;
      }
    } catch (e) {
      logger.e("Exception get me", error: e);
    }

    logger.t("Throw 'Not authorized'");
    return null;
  }
}