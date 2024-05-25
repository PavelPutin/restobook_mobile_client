import 'package:openid_client/openid_client.dart';

import 'auth_configuration.dart';
import 'open_id_auth_credential_provider_wrapper.dart';

abstract base class OpenIDAuthCredentialProvider {
  static OpenIDAuthCredentialProvider fromConfig(
      Client client,
      AuthConfiguration authConfiguration) {
    return OpenIDAuthCredentialProviderWrapper(
      client: client,
      configuration: authConfiguration,
    );
  }

  OpenIDAuthCredentialProvider();

  Future<Credential> authenticate();
  Future<Credential?> loadCredential();
}
