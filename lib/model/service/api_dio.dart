import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class Api {
  final Dio dio = Dio();
  //todo: to remove
  // final Dio retryDio = Dio(BaseOptions(baseUrl: 'https://restobook.fun'));
  final storage.FlutterSecureStorage secureStorage =
      const storage.FlutterSecureStorage();

  // todo: change
  // static const basePath = 'http://192.168.1.97:8181';
  static const basePath = 'https://restobook.fun';

  static const _accessTokenKey = "access_token";
  static const _refreshTokenKey = "refresh_token";

  void init() {


    dio.interceptors.addAll([
      QueuedInterceptorsWrapper(onRequest: (
        RequestOptions options,
        RequestInterceptorHandler handler,
      ) async {
        if (!options.path.startsWith(basePath)) {
          options.path = basePath + options.path;
        }
        final token = await secureStorage.read(key: _accessTokenKey);

        if (token == null) {
          // await secureStorage.write(key: _accessTokenKey, value: "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzdV9qTnh1bUJaTGhqNXpzLU1aOGNVaXlZS1pmc0xldTVBRVJNQzluTHRjIn0.eyJleHAiOjE3MTY4NzMxNTcsImlhdCI6MTcxNjg3Mjg1NywianRpIjoiMjQyM2Y4MTctZDE5ZS00ZGRhLTlkOGYtYzdmMDExOTkxOWIzIiwiaXNzIjoiaHR0cHM6Ly9yZXN0b2Jvb2suZnVuL3JlYWxtcy9yZXN0YXVyYW50IiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImZlYjUwNTFlLWExMzItNDkyZC1hZTIyLTU3NWEwMzIwMzlkNCIsInR5cCI6IkJlYXJlciIsImF6cCI6InJlc3RvYm9vay1yZXN0LWFwaSIsInNlc3Npb25fc3RhdGUiOiJiMWFiZDJmNy1iN2NhLTQ5NWItYThlYi1kMjBiYmJmNzM1ZjMiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbIioiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwiZGVmYXVsdC1yb2xlcy1yZXN0YXVyYW50IiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJyZXN0b2Jvb2stcmVzdC1hcGkiOnsicm9sZXMiOlsicmVzdG9ib29rX2FkbWluIl19LCJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6ImVtYWlsIHByb2ZpbGUiLCJzaWQiOiJiMWFiZDJmNy1iN2NhLTQ5NWItYThlYi1kMjBiYmJmNzM1ZjMiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInByZWZlcnJlZF91c2VybmFtZSI6InB1dGluIn0.XNSzjZkH_-JzEx838wpJQ_e40PTdVgfuY5-gnp_T4XvMbbzM4jxn8iptasNehNBAIQkewP8tX1PapC5cjH88zVs1Y5CSVWgNIOPdbdcbwd3FreJKj9WjJpgqb0FEsg8YBg17npVJo_dwBuiiObS1CIU2e0m5sziQfhOmL3biIRNcqCnHjD-FxBXU1F4q3PAiTi44RL8aGWUgVsA-ap-eX9z8vkoCQ8Xrq6k4MgSEHawgwuW_jeLOBgEIxcdNETJ5eC9phyeYN_7rH1lNbTX9G-SjKXU2Aa6L3g8ItcNfEceDu29VoWb5Ue34HMqn8UK9-QmUqIFCP0SoSTnQ9oCkmQ.eyJleHAiOjE3MTY4MzczMjgsImlhdCI6MTcxNjgzNzAyOCwianRpIjoiNzNhMDVlZTUtOGE4NS00MzFiLWFhMGItYWMyOGFiY2VmNGJmIiwiaXNzIjoiaHR0cHM6Ly9yZXN0b2Jvb2suZnVuL3JlYWxtcy9yZXN0YXVyYW50IiwiYXVkIjoiYWNjb3VudCIsInN1YiI6IjIwODczYmZkLTQ4MWItNGU1ZC1hYWI5LWRlNjAyNjM0MjkxYyIsInR5cCI6IkJlYXJlciIsImF6cCI6InJlc3RvYm9vay1yZXN0LWFwaSIsInNlc3Npb25fc3RhdGUiOiJiNDVhMWM4ZC0wZWY3LTQ5MmYtOWFiOS0zMTY5MDU2NGMyMDYiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbIioiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwiZGVmYXVsdC1yb2xlcy1yZXN0YXVyYW50IiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJyZXN0b2Jvb2stcmVzdC1hcGkiOnsicm9sZXMiOlsicmVzdG9ib29rX2FkbWluIl19LCJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6ImVtYWlsIHByb2ZpbGUiLCJzaWQiOiJiNDVhMWM4ZC0wZWY3LTQ5MmYtOWFiOS0zMTY5MDU2NGMyMDYiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInByZWZlcnJlZF91c2VybmFtZSI6InB1dGluX3BfYSJ9.a7CnNWJZky3qAL4R_94bPSSEaoohN2vxc4BX50Y3G0r6ijicwU60wBB0WOrsVCHEMIlS11uAcD4ncvSSnsTSOfU-xpvrCulZGPCbUbL0nfdhOIuIoxRH7XMb-kGk_kWfVmaisKy705Cf2DwMnwSATeC01tfZwhdDdGUilJhGvYh3H---VlSny0S7qD6STt0Od3P-RnmuE4SgzZDBG0q8GWYiqwmRhfRY1NWbWJvS1vb4btjOVLVTZHv056pO8nYkarlsy_qV0BvMGU6KyfXOpLb2AyIbUGJ1CA2prKzEMnriA7RNedP5nYNLrph5PIwxzh00mv2VhxWvYcezSsBNTQ");
          await secureStorage.write(key: _refreshTokenKey, value: "eyJhbGciOiJIUzUxMiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4NGZlNjUwNy05OTQ3LTQ3YmUtYjhmOS0xNmZjZjZkMWJiNDIifQ.eyJleHAiOjE3MTY4NzQ2NTcsImlhdCI6MTcxNjg3Mjg1NywianRpIjoiZjVhODI0N2EtMmZlYS00NzEwLWJkYmEtNjJjYTM4YWI4MjExIiwiaXNzIjoiaHR0cHM6Ly9yZXN0b2Jvb2suZnVuL3JlYWxtcy9yZXN0YXVyYW50IiwiYXVkIjoiaHR0cHM6Ly9yZXN0b2Jvb2suZnVuL3JlYWxtcy9yZXN0YXVyYW50Iiwic3ViIjoiZmViNTA1MWUtYTEzMi00OTJkLWFlMjItNTc1YTAzMjAzOWQ0IiwidHlwIjoiUmVmcmVzaCIsImF6cCI6InJlc3RvYm9vay1yZXN0LWFwaSIsInNlc3Npb25fc3RhdGUiOiJiMWFiZDJmNy1iN2NhLTQ5NWItYThlYi1kMjBiYmJmNzM1ZjMiLCJzY29wZSI6ImVtYWlsIHByb2ZpbGUiLCJzaWQiOiJiMWFiZDJmNy1iN2NhLTQ5NWItYThlYi1kMjBiYmJmNzM1ZjMifQ.worDfi30yyLJLkMndchjP7bPRP_aYJWk_81xmacZyuYzcgcdGWKl2z0D0Os4J7wBO30C2cHUweqrf1A7oabt5A");

        }

        if (token == null) {
          options.headers['Authorization'] = 'Bearer  ';
        } else {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      }, onResponse:
          (Response response, ResponseInterceptorHandler handler) async {
        return handler.next(response);
      }, onError: (DioException error, ErrorInterceptorHandler handler) async {
        print(error);
        if (error.response?.statusCode == 401) {
          try {
            final refreshToken = await secureStorage.read(
                key: _refreshTokenKey);
            if (refreshToken == null) {
              throw error;
            }
            // change retry dio to dio
            final response = await dio.post(
                '/realms/restaurant/protocol/openid-connect/token',
                data: {
                  'grant_type': 'refresh_token',
                  'client_id': 'restobook-rest-api',
                  'client_secret': 'm7Qpp1SGt63mdnrw9EDVdYBZ3TwH3t0W',
                  'refresh_token': refreshToken
                },
                options: Options(
                    contentType: Headers.formUrlEncodedContentType));

            if (response.statusCode == null ||
                response.statusCode! ~/ 100 != 2) {
              throw DioException(requestOptions: response.requestOptions);
            }

            var accessToken = response.data['access_token'];
            await secureStorage.write(key: _accessTokenKey, value: accessToken);
            var newRefreshToken = response.data['refresh_token'];
            await secureStorage.write(key: _refreshTokenKey, value: newRefreshToken);
            return handler.next(error);

          } on DioException catch (e) {
            return handler.reject(e);
          }
        }
      }),

      QueuedInterceptorsWrapper(
          onError: (error, handler) async {
            if (error.response != null && error.response!.statusCode == 401) {
              final result = await dio.fetch(error.requestOptions);
              return handler.resolve(result);
            }
          }
      )
    ]);
  }
}
