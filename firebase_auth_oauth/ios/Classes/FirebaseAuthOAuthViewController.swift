import Flutter
import UIKit
import FirebaseAuth

public class FirebaseAuthOAuthViewController: UIViewController, FlutterPlugin {
	
	internal var currentNonce: String?
	private var result: FlutterResult?
	var arguments: [String: String]?
	
	public static func register(with registrar: FlutterPluginRegistrar) {
		let channel = FlutterMethodChannel(name: "me.amryousef.apple.auth/firebase_auth_oauth", binaryMessenger: registrar.messenger())
		let instance = FirebaseAuthOAuthViewController()
		registrar.addMethodCallDelegate(instance, channel: channel)
	}
	
	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		self.result = result
		if let arguments = call.arguments as? [String:String] {
			let provider = arguments["provider"]
			if provider == "apple.com" {
				if #available(iOS 13.0, *) {
					signInWithApple(arguments: arguments)
				} else {
					finalizeResult(FirebaseAuthOAuthPluginError.PluginError(error: "Sign in by Apple is not supported for this iOS version"))
				}
			} else {
				oAuthSignIn(arguments: arguments)
			}
		} else {
			finalizeResult(FirebaseAuthOAuthPluginError.PluginError(error: "call arguments cannot be null"))
		}
	}
	
	func finalizeResult(_ error: FirebaseAuthOAuthPluginError) {
		finalizeResult(user: nil, error: error)
	}
	
	func finalizeResult(_ user: User) {
		finalizeResult(user: user, error: nil)
	}
	
	private func finalizeResult(user: User?, error: FirebaseAuthOAuthPluginError?) {
		if user != nil {
			result?("")
		}
		
		if error != nil {
			result?(error?.flutterError())
		}
		
		self.result = nil
	}
}
