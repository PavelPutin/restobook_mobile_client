import 'package:flutter/material.dart';
import 'package:restobook_mobile_client/model/entities/auth_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationViewModel extends ChangeNotifier {
  AuthEntity? _authorizedUser;
  bool _firstEnter = true;

  AuthEntity? get authorizedUser => _authorizedUser;

  bool get firstEnter => _firstEnter;

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
}
