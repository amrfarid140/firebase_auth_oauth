import 'dart:async';

import 'package:flutter/services.dart';

class FirebaseAppleAuth {
  static const MethodChannel _channel =
      const MethodChannel('firebase_apple_auth');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
