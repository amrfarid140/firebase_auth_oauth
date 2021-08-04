library firebase_apple_auth_platform_interface;

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

part 'method_channel_firebase_auth_oauth.dart';

/// Platform interface definition of [FirebaseAuthOAuth]
class FirebaseAuthOAuth {
  /// Default instance if [FirebaseAuthOAuth]
  static FirebaseAuthOAuth instance = MethodChannelFirebaseAuthOAuth._();

  FirebaseAuthOAuth._();

  /// Starts a OAuth sign-in flow for [provider]
  /// using Firebase. The instance of FirebaseAuth will be from the default Firebase App
  /// Unless [withApp] is used to build an instance
  Future<User?> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    throw UnimplementedError("openSignInFlow() is not implemented");
  }

  /// Starts a OAuth sign-in flow for [provider]
  /// using Firebase. The instance of FirebaseAuth will be from the default Firebase App
  /// Unless [withApp] is used to build an instance.
  /// The credentials will be added to the existing Firebase [User]
  /// An error will be throw if there's no Firebase [User]
  Future<User?> linkExistingUserWithCredentials(
      String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    throw UnimplementedError(
        "linkExistingUserWithCredentials() is not implemented");
  }

  /// Starts a OAuth sign-in flow for [provider] using Firebase.
  /// The instance of FirebaseAuth will be from the default Firebase App
  /// Unless [withApp] is used to build an instance
  /// It will return authentication result [OAuthCredential].
  /// If supported by Firebase, this will contains the provider access
  /// token as [accessToken].
  Future<OAuthCredential> signInOAuth(String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    throw UnimplementedError("signInOAuth() is not implemented");
  }

  /// Starts a OAuth sign-in flow for [provider] using Firebase.
  /// The instance of FirebaseAuth will be from the default Firebase App
  /// Unless [withApp] is used to build an instance.
  /// The credentials will be added to the existing Firebase [User]
  /// An error will be throw if there's no Firebase [User]
  /// It will return authentication result [OAuthCredential].
  /// If supported by Firebase, this will contains the provider access
  /// token as [accessToken].
  Future<OAuthCredential> linkWithOAuth(String provider, List<String> scopes,
      [Map<String, String>? customOAuthParameters]) async {
    throw UnimplementedError("linkWithOAuth() is not implemented");
  }

  /// Builds an instance of [FirebaseAuthOAuth] using a [FirebaseApp] instance
  FirebaseAuthOAuth withApp(FirebaseApp app) {
    throw UnimplementedError("withApp() is not implemented");
  }
}
