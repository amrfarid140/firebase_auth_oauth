library firebase_apple_auth;

import 'package:firebase_auth_oauth_platform_interface/firebase_auth_oauth_platform_interface.dart'
    as platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAppleAuth implements platform.FirebaseAuthOAuth {
  final platform.FirebaseAuthOAuth _delegate;

  FirebaseAppleAuth({FirebaseApp app})
      : _delegate = app != null
            ? platform.FirebaseAuthOAuth.instance.withApp(app)
            : platform.FirebaseAuthOAuth.instance;

  @override
  Future<FirebaseUser> openSignInFlow(String provider, List<String> scopes,
          [Map<String, String> customOAuthParameters]) =>
      _delegate.openSignInFlow(provider, scopes, customOAuthParameters);

  @override
  platform.FirebaseAuthOAuth withApp(FirebaseApp app) =>
      FirebaseAppleAuth(app: app);
}
