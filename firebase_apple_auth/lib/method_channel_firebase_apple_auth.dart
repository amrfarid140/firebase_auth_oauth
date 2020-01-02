  part of firebase_apple_auth;

  class MethodChannelFirebaseAppleAuth extends FirebaseAppleAuth {
    static const MethodChannel _channel =
        const MethodChannel('me.amryousef.apple.auth/firebase_apple_auth');

    MethodChannelFirebaseAppleAuth._({FirebaseApp app}) : super._(app: app);

    @override
    Future<FirebaseUser> openSignInFlow() async {
      await _channel.invokeMethod("openSignInFlow", {'app': _app.name});
      return FirebaseAuth.fromApp(_app).currentUser();
    }
  }
