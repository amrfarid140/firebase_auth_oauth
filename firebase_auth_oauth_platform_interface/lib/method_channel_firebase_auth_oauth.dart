part of firebase_apple_auth_platform_interface;

class MethodChannelFirebaseAuthOAuth extends FirebaseAuthOAuth {
  final FirebaseApp _app;

  static const MethodChannel _channel =
      const MethodChannel('me.amryousef.apple.auth/firebase_apple_auth');

  MethodChannelFirebaseAuthOAuth._({FirebaseApp app})
      : _app = app ?? FirebaseApp.instance,
        super._();

  @override
  Future<FirebaseUser> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String> customOAuthParameters]) async {
    await _channel.invokeMethod("openSignInFlow", {
      'provider': provider,
      'app': _app.name,
      'scopes': json.encode(scopes),
      if (customOAuthParameters != null)
        'parameters': json.encode(customOAuthParameters)
    });
    return FirebaseAuth.fromApp(_app).currentUser();
  }
}
