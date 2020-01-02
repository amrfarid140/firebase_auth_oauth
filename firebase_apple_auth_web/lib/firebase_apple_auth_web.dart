import 'dart:async';

import 'package:flutter/services.dart';

class FirebaseAppleAuthWeb {
  static const MethodChannel _channel =
      const MethodChannel('firebase_apple_auth_web');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
