import 'package:firebase/firebase.dart' as web;
import 'package:firebase_apple_auth_platform_interface/firebase_apple_auth_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FirebaseAppleAuthWeb implements FirebaseAppleAuth {

  static void registerWith(Registrar registrar) {
    FirebaseAppleAuth.instance = FirebaseAppleAuthWeb._();
  }

  FirebaseAppleAuthWeb._();

  @override
  Future<FirebaseUser> openSignInFlow() async {
    final provider = web.OAuthProvider('apple.com')..addScope("email");
    await web.app().auth().signInWithPopup(provider);
    return FirebaseAuth.instance.currentUser();
  }

}
