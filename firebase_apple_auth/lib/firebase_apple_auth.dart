library firebase_apple_auth;

import 'package:firebase_apple_auth_platform_interface/firebase_apple_auth_platform_interface.dart'
    as platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAppleAuth implements platform.FirebaseAppleAuth {
  final platform.FirebaseAppleAuth _delegate;

  FirebaseAppleAuth({FirebaseApp app})
      : _delegate = app != null
            ? platform.FirebaseAppleAuth.instance.withApp(app)
            : platform.FirebaseAppleAuth.instance;

  @override
  Future<FirebaseUser> openSignInFlow(String provider, List<String> scopes,
          [Map<String, String> customOAuthParameters]) =>
      _delegate.openSignInFlow(provider, scopes, customOAuthParameters);

  @override
  platform.FirebaseAppleAuth withApp(FirebaseApp app) =>
      FirebaseAppleAuth(app: app);
}
