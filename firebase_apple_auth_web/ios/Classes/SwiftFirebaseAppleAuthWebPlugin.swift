import Flutter
import UIKit

public class SwiftFirebaseAppleAuthWebPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "firebase_apple_auth_web", binaryMessenger: registrar.messenger())
    let instance = SwiftFirebaseAppleAuthWebPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
