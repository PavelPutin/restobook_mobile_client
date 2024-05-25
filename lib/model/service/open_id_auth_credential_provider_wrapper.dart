import 'dart:async';

import 'package:restobook_mobile_client/model/service/open_id_auth_credential_provider.dart';

final class OpenIDAuthCredentialProviderWrapper
    extends OpenIDAuthCredentialProvider {
  final Client _client;
  final AuthConfiguration _configuration;

  OpenIDAuthCredentialProviderWrapper(
      {required Client client, required AuthConfiguration configuration})
      : _client = client,
        _configuration = configuration;

  @override
  Future<Credential> authenticate() async {
    var authenticator = browser.Authenticator(
      _client,
      scopes: _configuration.scopes,
    );
    authenticator.authorize();
    return Completer<Credential>().future;
  }

  @override
  Future<Credential?> loadCredential() async {
    var authenticator = browser.Authenticator(
      _client,
      scopes: _configuration.scopes,
    );
    var c = await authenticator.credential;
    return c;
  }
}
