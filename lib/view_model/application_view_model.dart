import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:restobook_mobile_client/model/entities/auth_entity.dart';
import 'package:restobook_mobile_client/model/service/abstract_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationViewModel extends ChangeNotifier {
  AbstractAuthService authService = GetIt.I<AbstractAuthService>();
  AuthEntity? _authorizedUser;
  bool _firstEnter = true;

  AuthEntity? get authorizedUser => _authorizedUser;

  bool get firstEnter => _firstEnter;
  bool get authorized => _authorizedUser != null;
  bool get isAdmin => _authorizedUser != null && _authorizedUser!.role == "ROLE_ADMIN";

  void initIsFirstEnter() {
    SharedPreferences.getInstance().then((preferences) {
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

  Future<void> login(String username, String password) async {
    await authService.login(username, password)
        .then((value) => _authorizedUser = value);
    notifyListeners();
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
