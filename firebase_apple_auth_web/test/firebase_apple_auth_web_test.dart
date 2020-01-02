import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_apple_auth_web/firebase_apple_auth_web.dart';

void main() {
  const MethodChannel channel = MethodChannel('firebase_apple_auth_web');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FirebaseAppleAuthWeb.platformVersion, '42');
  });
}
