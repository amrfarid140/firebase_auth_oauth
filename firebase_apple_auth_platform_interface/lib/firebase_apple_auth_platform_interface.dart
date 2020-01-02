library firebase_apple_auth_platform_interface;

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

part 'method_channel_firebase_apple_auth.dart';

class FirebaseAppleAuth {
  static FirebaseAppleAuth instance = MethodChannelFirebaseAppleAuth._();
  final FirebaseApp _app;

  FirebaseAppleAuth._({FirebaseApp app}) : _app = app ?? FirebaseApp.instance;

  Future<FirebaseUser> openSignInFlow() async {
    throw UnimplementedError("openSignInFlow() is not implemeneted");
  }
}
