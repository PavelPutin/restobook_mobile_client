import 'dart:async';
import 'dart:io';


import 'package:restobook_mobile_client/model/service/open_id_auth_credential_provider.dart';
import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_browser.dart';
import 'package:openid_client/openid_client_io.dart' as io;
import 'package:url_launcher/url_launcher.dart';

import 'auth_configuration.dart';

final class OpenIDAuthCredentialProviderWrapper
    extends OpenIDAuthCredentialProvider {
  final Client _client;
  final AuthConfiguration _configuration;

  OpenIDAuthCredentialProviderWrapper(
      {required Client client, required AuthConfiguration configuration})
      : _client = client, _configuration = configuration;

  Future<void> _tryLaunch(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri) || Platform.isAndroid) {
      await launchUrl(uri);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Future<Credential> authenticate() async {
    var authenticator = io.Authenticator.fromFlow(
      Flow.authorizationCode(
        _client,
        redirectUri: Uri.parse('http://localhost:4000/'),
      ),
      urlLancher: _tryLaunch
    );
    var c = await authenticator.authorize();
    if (Platform.isAndroid || Platform.isIOS) {
      await closeInAppWebView();
    }
    return c;
  }

  @override
  Future<Credential?> loadCredential() async {
    return null;
  }
}
