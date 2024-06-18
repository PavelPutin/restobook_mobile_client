import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class Api {
  Logger logger = GetIt.I<Logger>();

  final Dio dio = Dio();

  final storage.FlutterSecureStorage secureStorage =
      const storage.FlutterSecureStorage();

  static const basePath = 'https://restobook.fun';

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const clientId = 'restobook-rest-api';
  static const clientSecret = String.fromEnvironment("KeycloakRestobookRestApiClientSecret");

  void init() {
    dio.interceptors.addAll([
      QueuedInterceptorsWrapper(onRequest: (
        RequestOptions options,
        RequestInterceptorHandler handler,
      ) async {
        logger.t("Options path is ${options.path}");
        if (!options.path.startsWith(basePath)) {
          options.path = basePath + options.path;
        }
        logger.t("Options path after base path is ${options.path}");

        final token = await secureStorage.read(key: accessTokenKey);
        logger.t("Contains token ${token != null}");

        options.headers['Authorization'] = 'Bearer ${token ?? ""}';
        return handler.next(options);

      }, onResponse: (response, handler) {
        return handler.resolve(response);
      }, onError: (DioException error, ErrorInterceptorHandler handler) async {
        logger.e("Api got error\n", error: error);
        logger.e("Response status code\n${error.response?.statusCode}");

        if (error.response?.statusCode == 401) {
          logger.e("Start process anauthorized request");
          try {
            if ((error.response?.data ?? "").toString().isNotEmpty && error.response?.data['error'] == 'invalid_grant') {
              logger.e("Invalid_grant error");
              return handler.reject(error);
            }

            logger.e("Access token expired error");
            final tokenDio = Dio(
              BaseOptions(
                  baseUrl: basePath,
              ),
            );

            final refreshToken = await secureStorage.read(key: refreshTokenKey);
            logger.t("Contains refresh token ${refreshToken != null}");
            if (refreshToken == null) {
              logger.e("Doesn't have refresh token");
              return handler.reject(error);
            }


            final response = await tokenDio.post(
                '/realms/restaurant/protocol/openid-connect/token',
                data: {
                  'grant_type': 'refresh_token',
                  'client_id': clientId,
                  'client_secret': clientSecret,
                  'refresh_token': refreshToken
                },
                options:
                Options(contentType: Headers.formUrlEncodedContentType));

            logger.t("Refresh response status ${response.statusCode} ${response.statusMessage}");

            if (response.statusCode == null ||
                response.statusCode! ~/ 100 != 2) {
              logger.e("Error get refresh token");
              throw DioException(requestOptions: response.requestOptions);
            }

            logger.t("Get refresh token");
            var accessToken = response.data['access_token'];
            await secureStorage.write(key: accessTokenKey, value: accessToken);
            logger.t("Set accessToken");
            var newRefreshToken = response.data['refresh_token'];
            await secureStorage.write(
                key: refreshTokenKey, value: newRefreshToken);
            logger.t("Set refreshToken");
            logger.t("Finish process anauthorized request");
            return handler.next(error);
          } on DioException catch (e) {
            logger.e("Dio exception in anauthorized request processing", error: e);
            // return handler.reject(e);
            return handler.reject(error);
          }
        }
        logger.e("Reject errored request");
        return handler.reject(error);
      }),

      QueuedInterceptorsWrapper(onError: (error, handler) async {
        logger.t("Second QueuedInterceptorsWrapper");
        if (error.response != null && error.response!.statusCode == 401) {
          logger.t("Retry request");
          final result = await dio.fetch(error.requestOptions);
          logger.t("Successfuly retry request");
          return handler.resolve(result);
        }
      })
    ]);
  }
}
