import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:openid_client/openid_client.dart';
import 'package:restobook_mobile_client/model/service/auth_configuration.dart';
import 'package:restobook_mobile_client/model/service/open_id_auth_credential_provider.dart';

import 'credential_storage.dart';

class AuthClient {
  final Client _client;
  Credential? _credential;
  final _authorizedNotifier = ValueNotifier<bool>(false);
  final CredentialStorage _credentialStorage;
  final OpenIDAuthCredentialProvider _authCredentialProvider;

  AuthClient._({required Client client,
    required OpenIDAuthCredentialProvider authCredentialProvider,
    required CredentialStorage credentialStorage})
      : _client = client,
        _authCredentialProvider = authCredentialProvider,
        _credentialStorage = credentialStorage;

  static Future<AuthClient> createAuthClient(AuthConfiguration authConfig,
      CredentialStorage credentialStorage) async {
    final issuer = await Issuer.discover(Uri.parse(authConfig.authUrl));

    final client = Client(
        issuer,
        authConfig.clientId,
        clientSecret: authConfig.clientSecret
    );

    final authClient = AuthClient._(
        client: client,
        authCredentialProvider: OpenIDAuthCredentialProvider.fromConfig(
            client, authConfig),
        credentialStorage: credentialStorage
    );

    await authClient.init();
    return authClient;
  }

  ValueListenable<bool> get authorizedListenable => _authorizedNotifier;

  String ? get accessToken => _credential?.response?['access_token'];

  Future<void> init() async {
    final credential = await _authCredentialProvider.loadCredential();
    if (credential == null) {
      _credential = await _credentialStorage.loadCredential();
    } else {
      _credential = credential;
      await _credentialStorage.saveTokens(credential);
    }
    _authorizedNotifier.value = _credential != null;
  }

  Future<void> refresh() async {
    final credential = _credential;
    if (credential == null) {
      // TODO: уточнить
    }
  }

  Future<void> logout() async {
    _credential = null;
    _authorizedNotifier.value = false;
    await _credentialStorage.deleteTokens();
  }

  Future<void> authenticate() async {
    final credential = await _authCredentialProvider.authenticate();
    _credential = credential;
    await _credentialStorage.saveTokens(credential);
    _authorizedNotifier.value = _credential != null;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userInfo = await _credential?.getUserInfo();
      return userInfo?.toJson();
    } on Object catch (e) {
      unawaited(logout());
    }
    return null;
  }
}
