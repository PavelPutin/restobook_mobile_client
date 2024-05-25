class AuthConfiguration {
  final String authUrl;
  final String clientId;
  final String clientSecret;

  AuthConfiguration(
      {required this.authUrl,
      required this.clientId,
      required this.clientSecret});
}
