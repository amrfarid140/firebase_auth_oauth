import Flutter
import UIKit
import FirebaseAuth

public class FirebaseAuthOAuthViewController: UIViewController, FlutterPlugin {
	
	private static let CREATE_USER_METHOD = "openSignInFlow"
	private static let LINK_USER_METHOD = "linkExistingUserWithCredentials"
	
	internal var currentNonce: String?
	private var call: FlutterMethodCall?
	private var result: FlutterResult?
	private(set) public var authProvider: OAuthProvider?
	var arguments: [String: String]?
	
	public static func register(with registrar: FlutterPluginRegistrar) {
		let channel = FlutterMethodChannel(name: "me.amryousef.apple.auth/firebase_auth_oauth", binaryMessenger: registrar.messenger())
		let instance = FirebaseAuthOAuthViewController()
		registrar.addMethodCallDelegate(instance, channel: channel)
	}
	
	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		self.result = result
		self.call = call
		if let arguments = call.arguments as? [String:String] {
			guard let providerId = arguments["provider"] else {
				finalizeResult(
					FirebaseAuthOAuthPluginError
						.PluginError(error: "Provider argument cannot be null")
				)
				return
			}
			if providerId == "apple.com" {
				if #available(iOS 13.0, *) {
					signInWithApple(arguments: arguments)
				} else {
					finalizeResult(FirebaseAuthOAuthPluginError.PluginError(error: "Sign in by Apple is not supported for this iOS version"))
				}
			} else {
				authProvider = OAuthProvider(providerID: providerId)
				oAuthSignIn(arguments: arguments)
			}
		} else {
			finalizeResult(FirebaseAuthOAuthPluginError.PluginError(error: "call arguments cannot be null"))
		}
	}
	
	func consumeCredentials(_ credential: AuthCredential) {
		if call?.method == FirebaseAuthOAuthViewController.CREATE_USER_METHOD {
			Auth.auth().signIn(with: credential) { authResult, error in
                guard let currentUser = Auth.auth().currentUser else {
                    self.finalizeResult(.PluginError(error: "currentUser is nil. Make sure a user exists when \(FirebaseAuthOAuthViewController.CREATE_USER_METHOD) is used."))
                    return
                }
				if let firebaseError = error {
					self.finalizeResult(
						FirebaseAuthOAuthPluginError
							.FirebaseAuthError(error: firebaseError)
					)
				}
				self.finalizeResult(currentUser)
			}
		}
		if call?.method == FirebaseAuthOAuthViewController.LINK_USER_METHOD {
			guard let currentUser = Auth.auth().currentUser else {
				self.finalizeResult(.PluginError(error: "currentUser is nil. Make sure a user exists when \(FirebaseAuthOAuthViewController.LINK_USER_METHOD) is used."))
				return
			}
			currentUser.link(with: credential) { (result, error) in
                if let firebaseError = error {
                    self.finalizeResult(
                        FirebaseAuthOAuthPluginError
                            .FirebaseAuthError(error: firebaseError)
                    )
                }
                self.finalizeResult(currentUser)
			}
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
		
		self.call = nil
		self.result = nil
		self.authProvider = nil
	}
}
