part of firebase_apple_auth_platform_interface;

/// Method channel implementation of [FirebaseAuthOAuth]
class MethodChannelFirebaseAuthOAuth extends FirebaseAuthOAuth {
  final FirebaseApp _app;

  static const MethodChannel _channel =
      const MethodChannel('me.amryousef.apple.auth/firebase_auth_oauth');

  MethodChannelFirebaseAuthOAuth._({FirebaseApp app})
      : _app = app ?? Firebase.app(),
        super._();

  @override
  Future<User> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String> customOAuthParameters]) async {
    await _channel.invokeMethod("openSignInFlow", {
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
