import 'package:firebase/firebase.dart' as web;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth_platform_interface/firebase_auth_oauth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

typedef _AppProvider = FirebaseApp Function();

/// Web implementation for [FirebaseAuthOAuth]
class FirebaseAuthOAuthWeb implements FirebaseAuthOAuth {
  _AppProvider _app = () => Firebase.app();

  /// Register this implementation as the default [FirebaseAuthOAuth] instance
  /// Shouldn't be used inside a project. It is automatically invoked by Flutter build system.
  static void registerWith(Registrar registrar) {
    FirebaseAuthOAuth.instance = FirebaseAuthOAuthWeb._();
  }

  FirebaseAuthOAuthWeb._({FirebaseApp? app}) {
    if (app != null) {
      _app = () => app;
    }
  }

  @override
  Future<User?> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    final oAuthProvider = web.OAuthProvider(provider);
    scopes.forEach((scope) => oAuthProvider.addScope(scope));
    if (customOAuthParameters != null) {
      oAuthProvider.setCustomParameters(customOAuthParameters);
    }
    await web.app(_app().name).auth().signInWithPopup(oAuthProvider);
    return FirebaseAuth.instanceFor(app: _app()).currentUser;
  }

  @override
  Future<User?> linkExistingUserWithCredentials(
      String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    final oAuthProvider = web.OAuthProvider(provider);
    scopes.forEach((scope) => oAuthProvider.addScope(scope));
    if (customOAuthParameters != null) {
      oAuthProvider.setCustomParameters(customOAuthParameters);
    }
    if (FirebaseAuth.instanceFor(app: _app()).currentUser == null) {
      return Future.error(StateError(
          "currentUser is nil. Make sure a user exists when linkExistingUserWithCredentials is used"));
    }
    await web.app(_app().name).auth().currentUser?.linkWithPopup(oAuthProvider);
    return FirebaseAuth.instanceFor(app: _app()).currentUser;
  }

  @override
  Future<OAuthCredential> signInOAuth(String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    final oAuthProvider = web.OAuthProvider(provider);
    scopes.forEach((scope) => oAuthProvider.addScope(scope));
    if (customOAuthParameters != null) {
      oAuthProvider.setCustomParameters(customOAuthParameters);
    }
    final result =
        await web.app(_app().name).auth().signInWithPopup(oAuthProvider);

    return OAuthCredential(
      signInMethod: "oauth",
      providerId: result.credential.providerId,
      accessToken: result.credential.accessToken,
      idToken: result.credential.idToken,
      secret: result.credential.secret,
    );
  }

  @override
  Future<OAuthCredential> linkWithOAuth(String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    final oAuthProvider = web.OAuthProvider(provider);
    scopes.forEach((scope) => oAuthProvider.addScope(scope));
    if (customOAuthParameters != null) {
      oAuthProvider.setCustomParameters(customOAuthParameters);
    }
    if (FirebaseAuth.instanceFor(app: _app()).currentUser == null) {
      return Future.error(StateError(
          "currentUser is nil. Make sure a user exists when linkWithOAuth is used"));
    }
    final result = await web
        .app(_app().name)
        .auth()
        .currentUser
        ?.linkWithPopup(oAuthProvider);

    return OAuthCredential(
      signInMethod: "oauth",
      providerId: result?.credential.providerId ?? "",
      accessToken: result?.credential.accessToken,
      idToken: result?.credential.idToken,
      secret: result?.credential.secret,
    );
  }

  @override
  FirebaseAuthOAuth withApp(FirebaseApp app) =>
      FirebaseAuthOAuthWeb._(app: app);
}
