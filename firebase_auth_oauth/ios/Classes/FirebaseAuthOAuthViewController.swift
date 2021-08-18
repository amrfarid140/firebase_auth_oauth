import Flutter
import UIKit
import FirebaseAuth

public class FirebaseAuthOAuthViewController: UIViewController, FlutterPlugin {
	private static let CREATE_USER_METHOD = "signInOAuth"
	private static let LINK_USER_METHOD = "linkWithOAuth"
	
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
				self.finalizeResult(authResult, currentUser)
			}
		}
		if call?.method == FirebaseAuthOAuthViewController.LINK_USER_METHOD {
			guard let currentUser = Auth.auth().currentUser else {
				self.finalizeResult(.PluginError(error: "currentUser is nil. Make sure a user exists when \(FirebaseAuthOAuthViewController.LINK_USER_METHOD) is used."))
				return
			}
			currentUser.link(with: credential) { (authResult, error) in
                if let firebaseError = error {
                    self.finalizeResult(
                        FirebaseAuthOAuthPluginError
                            .FirebaseAuthError(error: firebaseError)
                    )
                }
                if authResult != nil {
                    self.finalizeResult(authResult, currentUser)
                }
			}
		}
	}
	
	func finalizeResult(_ error: FirebaseAuthOAuthPluginError) {
		finalizeResult(authResult: nil, user: nil, error: error)
	}
	
	func finalizeResult(_ user: User) {
		finalizeResult(authResult: nil, user: user, error: nil)
	}

	func finalizeResult(_ authResult: AuthDataResult?, _ user: User) {
		finalizeResult(authResult: authResult, user: user, error: nil)
	}
	
	private func finalizeResult(authResult: AuthDataResult?, user: User?, error: FirebaseAuthOAuthPluginError?) {
		if user != nil {
			if authResult != nil {
				let credential = authResult!.credential
				if credential is OAuthCredential {
                    let oauthCredential = credential as! OAuthCredential?
					result?([
						"providerId": authResult?.credential?.provider,
						"accessToken": oauthCredential?.accessToken,
						"idToken": oauthCredential?.idToken,
						"secret": oauthCredential?.secret
					])
				} else {
					result?([
						"providerId": authResult?.credential?.provider
					])
				}
			} else {
				result?(nil)
			}
		}
		
		if error != nil {
			result?(error?.flutterError())
		}
		
		self.call = nil
		self.result = nil
		self.authProvider = nil
	}
}
