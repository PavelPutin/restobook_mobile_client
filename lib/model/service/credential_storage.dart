import 'dart:convert';

import 'package:openid_client/openid_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class CredentialStorage {
  static const _key = "credential";
  final _storage = const FlutterSecureStorage();

  Credential? _cachedCredentials;

  Future<Credential?> loadCredential() async {
    if (_cachedCredentials != null) {
      return _cachedCredentials;
    }
    final json = await _storage.read(key: _key);
    if (json == null) {
      return null;
    }
    try {
      _cachedCredentials = Credential.fromJson(jsonDecode(json));
      return _cachedCredentials;
    } on Object catch (e) {
      return null;
    }
  }

  Future<void> deleteTokens() {
    _cachedCredentials = null;
    return _storage.delete(key: _key);
  }

  Future<void> saveTokens(Credential credential) {
    _cachedCredentials = credential;
    return _storage.write(key: _key, value: jsonEncode(credential.toJson()));
  }
}