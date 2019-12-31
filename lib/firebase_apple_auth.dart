library firebase_apple_auth;

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class FirebaseAppleAuth {
  static const MethodChannel _channel =
      const MethodChannel('me.amryousef.apple.auth/firebase_apple_auth');

  final FirebaseApp _app;

  FirebaseAppleAuth({FirebaseApp app}) : _app = app ?? FirebaseApp.instance;

  Future<FirebaseUser> openSignInFlow() async {
    await _channel.invokeMethod("openSignInFlow", {'app': _app.name});
    return FirebaseAuth.fromApp(_app).currentUser();
  }
}
