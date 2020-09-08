part of firebase_apple_auth_platform_interface;

/// Method channel implementation of [FirebaseAuthOAuth]
class MethodChannelFirebaseAuthOAuth extends FirebaseAuthOAuth {
  FirebaseApp _app;

  static const MethodChannel _channel =
      const MethodChannel('me.amryousef.apple.auth/firebase_auth_oauth');

  MethodChannelFirebaseAuthOAuth._({FirebaseApp app})
      : _app = app,
        super._();

  @override
  Future<User> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String> customOAuthParameters]) async {
    _ensureAppInitialised();
    await _channel.invokeMethod("openSignInFlow", {
      'provider': provider,
      'app': _app.name,
      'scopes': json.encode(scopes),
      if (customOAuthParameters != null)
        'parameters': json.encode(customOAuthParameters)
    });
    return FirebaseAuth
        .instanceFor(app: _app)
        .currentUser;
  }

  @override
  Future<User> linkExistingUserWithCredentials(String provider,
      List<String> scopes,
      [Map<String, String> customOAuthParameters]) async {
    _ensureAppInitialised();
    await _channel.invokeMethod("linkExistingUserWithCredentials", {
      'provider': provider,
      'app': _app.name,
      'scopes': json.encode(scopes),
      if (customOAuthParameters != null)
        'parameters': json.encode(customOAuthParameters)
    });
    return FirebaseAuth
        .instanceFor(app: _app)
        .currentUser;
  }

  @override
  FirebaseAuthOAuth withApp(FirebaseApp app) =>
      MethodChannelFirebaseAuthOAuth._(app: app);

  void _ensureAppInitialised() {
    if (_app == null) {
      _app = Firebase.app();
    }
  }
}
