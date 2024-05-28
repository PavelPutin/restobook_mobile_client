import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:restobook_mobile_client/model/entities/auth_entity.dart';
import 'package:restobook_mobile_client/model/service/abstract_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationViewModel extends ChangeNotifier {
  Logger logger = GetIt.I<Logger>();

  AbstractAuthService authService = GetIt.I<AbstractAuthService>();
  AuthEntity? _authorizedUser;
  bool _firstEnter = true;

  AuthEntity? get authorizedUser => _authorizedUser;

  bool get firstEnter => _firstEnter;
  bool get authorized => _authorizedUser != null;
  bool get isAdmin => _authorizedUser != null && _authorizedUser!.role == "ROLE_ADMIN";

  Future<void> initIsFirstEnter() async {
    await SharedPreferences.getInstance().then((preferences) {
      _firstEnter = preferences.getBool("isFirst") ?? true;
      notifyListeners();
    }).onError((error, stackTrace) {
      _firstEnter = true;
      notifyListeners();
    });
  }

  void enter() {
    SharedPreferences.getInstance().then((preferences) {
      preferences.setBool("isFirst", false);
      _firstEnter = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      _firstEnter = true;
      notifyListeners();
    });
  }

  Future<void> getMe() async {
    // await authService.getMe()
    //     .then((value) => _authorizedUser = value)
    //     .onError((error, stackTrace) {
    //       print("GET_ME $error");
    //       _authorizedUser = null;
    //     })
    // ;
    logger.t("View model try get me");
    try {
      _authorizedUser = await authService.getMe();
      logger.t("View model successfuly get me");
    } catch (_) {
      logger.t("View model catch an exception in get me");
      _authorizedUser = null;
    }
    logger.t("View model notify listeners");
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    // await authService.login(username, password)
    //     .then((value) => _authorizedUser = value);
    try {
      _authorizedUser = await authService.login(username, password);
      notifyListeners();
    } on DioException catch (e) {
      _authorizedUser = null;
      notifyListeners();
      logger.e("Application view model catch dio exception", error: e);
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    if (_authorizedUser != null && _authorizedUser!.password == oldPassword) {
      await authService.changePassword(_authorizedUser!, newPassword);
      notifyListeners();
    } else {
      throw Exception("Старый пароль неверный");
    }
  }

  void logout() {
    _authorizedUser = null;
    notifyListeners();
  }
}
