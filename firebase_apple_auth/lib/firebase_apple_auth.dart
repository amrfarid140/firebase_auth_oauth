library firebase_apple_auth;

import 'package:firebase_apple_auth_platform_interface/firebase_apple_auth_platform_interface.dart' as platform;
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAppleAuth implements platform.FirebaseAppleAuth {

  @override
  Future<FirebaseUser> openSignInFlow() =>
      platform.FirebaseAppleAuth.instance.openSignInFlow();
}
