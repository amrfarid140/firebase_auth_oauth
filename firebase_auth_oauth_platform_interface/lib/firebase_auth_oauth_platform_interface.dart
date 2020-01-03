library firebase_apple_auth_platform_interface;

import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

part 'method_channel_firebase_auth_oauth.dart';

class FirebaseAuthOAuth {
  static FirebaseAuthOAuth instance = MethodChannelFirebaseAuthOAuth._();

  FirebaseAuthOAuth._();

  Future<FirebaseUser> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String> customOAuthParameters]) async {
    throw UnimplementedError("openSignInFlow() is not implemeneted");
  }

  FirebaseAuthOAuth withApp(FirebaseApp app) {
    throw UnimplementedError("withApp() is not implemeneted");
  }
}
