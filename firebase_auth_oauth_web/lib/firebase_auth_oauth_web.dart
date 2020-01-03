import 'package:firebase/firebase.dart' as web;
import 'package:firebase_auth_oauth_platform_interface/firebase_auth_oauth_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FirebaseAuthOAuthWeb implements FirebaseAuthOAuth {
  final FirebaseApp _app;

  static void registerWith(Registrar registrar) {
    FirebaseAuthOAuth.instance = FirebaseAuthOAuthWeb._();
  }

  FirebaseAuthOAuthWeb._({FirebaseApp app})
      : _app = app ?? FirebaseApp.instance;

  @override
  Future<FirebaseUser> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String> customOAuthParameters]) async {
    final oAuthProvider = web.OAuthProvider(provider);
    scopes.forEach((scope) => oAuthProvider.addScope(scope));
    if (customOAuthParameters != null) {
      oAuthProvider.setCustomParameters(customOAuthParameters);
    }
    await web.app(_app.name).auth().signInWithPopup(oAuthProvider);
    return FirebaseAuth.instance.currentUser();
  }

  @override
  FirebaseAuthOAuth withApp(FirebaseApp app) =>
      FirebaseAuthOAuthWeb._(app: app);
}
