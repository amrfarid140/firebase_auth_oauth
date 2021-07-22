part of firebase_apple_auth_platform_interface;

/// Method channel implementation of [FirebaseAuthOAuth]
class MethodChannelFirebaseAuthOAuth extends FirebaseAuthOAuth {
  FirebaseApp _app;

  OAuthCredential? _credential;

  static const MethodChannel _channel =
      const MethodChannel('me.amryousef.apple.auth/firebase_auth_oauth');

  MethodChannelFirebaseAuthOAuth._({FirebaseApp? app})
      : _app = app == null ? Firebase.app() : app,
        super._();

  @override
  OAuthCredential? get credential => this._credential;

  @override
  Future<User?> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    final data = await _channel.invokeMethod("openSignInFlow", {
      'provider': provider,
      'app': _app.name,
      'scopes': json.encode(scopes),
      if (customOAuthParameters != null)
        'parameters': json.encode(customOAuthParameters)
    });
    _credential = OAuthCredential(
      providerId: data?["providerId"] ?? "",
      signInMethod: data?["providerId"] ?? "",
      accessToken: data?["accessToken"] ?? "",
      idToken: data?["idToken"] ?? "",
      secret: data?["secret"] ?? "",
      rawNonce: data?["rawNonce"] ?? "",
    );
    return FirebaseAuth.instanceFor(app: _app).currentUser;
  }

  @override
  Future<User?> linkExistingUserWithCredentials(
      String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    await _channel.invokeMethod("linkExistingUserWithCredentials", {
      'provider': provider,
      'app': _app.name,
      'scopes': json.encode(scopes),
      if (customOAuthParameters != null)
        'parameters': json.encode(customOAuthParameters)
    });
    return FirebaseAuth.instanceFor(app: _app).currentUser;
  }

  @override
  FirebaseAuthOAuth withApp(FirebaseApp app) =>
      MethodChannelFirebaseAuthOAuth._(app: app);
}
