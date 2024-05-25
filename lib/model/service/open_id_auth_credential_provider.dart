abstract base class OpenIDAuthCredentialProvider {
  static OpenIDAuthCredentialProvider fromConfig(
      Client client,
      AuthConfiguration authConfiguration) {
    return OpenIdAuthCredentialProviderWrapper(
      client: client,
      configuration: authConfiguration,
    );
  }

  OpenIDAuthCredentialProvider();

  Future<Credential> authenticate();
  Future<Credential?> loadCredential();
}
