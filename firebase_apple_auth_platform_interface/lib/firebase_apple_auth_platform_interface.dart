library firebase_apple_auth_platform_interface;

import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

part 'method_channel_firebase_apple_auth.dart';

class FirebaseAppleAuth {
  static FirebaseAppleAuth instance = MethodChannelFirebaseAppleAuth._();

  FirebaseAppleAuth._();

  Future<FirebaseUser> openSignInFlow(String provider, List<String> scopes,
      [Map<String, String> customOAuthParameters]) async {
    throw UnimplementedError("openSignInFlow() is not implemeneted");
  }

  FirebaseAppleAuth withApp(FirebaseApp app) {
    throw UnimplementedError("withApp() is not implemeneted");
  }
}
