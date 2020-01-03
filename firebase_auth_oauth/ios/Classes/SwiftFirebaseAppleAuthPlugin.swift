import Flutter
import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

public class SwiftFirebaseAppleAuthPlugin: UIViewController, FlutterPlugin, ASAuthorizationControllerDelegate {
	
	private var currentNonce: String?
	var result: FlutterResult?
	var arguments: [String: String]?
	
	public static func register(with registrar: FlutterPluginRegistrar) {
		let channel = FlutterMethodChannel(name: "me.amryousef.apple.auth/firebase_apple_auth", binaryMessenger: registrar.messenger())
		let instance = SwiftFirebaseAppleAuthPlugin()
		registrar.addMethodCallDelegate(instance, channel: channel)
	}
	
	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		if let arguments = call.arguments as? [String:String] {
			let provider = arguments["provider"]
			if (provider == "apple.com") {
				signInWithApple(arguments: arguments, result: result)
			} else {
				oAuthSignIn(arguments: arguments, result: result)
			}
		} else {
			fatalError("no call arguments found")
		}
	}
	
	private func oAuthSignIn(arguments: [String: String], result: @escaping FlutterResult) {
		guard let providerId = arguments["provider"] else {
			fatalError("provider can't be nil")
		}
		let provider = OAuthProvider(providerID: providerId)
		guard let scopesString = arguments["scopes"] else {
			fatalError("scopes can't be nil")
		}
		let parametersString = arguments["parameters"]
		do {
			if let data = scopesString.data(using: .utf8) {
				if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String]
				{
					provider.scopes = jsonArray
				} else {
					fatalError("Invalid scopes list")
				}
				
			} else {
				fatalError("Scopes not defined")
			}
			
			if let data = parametersString?.data(using: .utf8) {
				if let jsonObject = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String, String>
				{
					provider.customParameters = jsonObject
				}
			}
			provider.getCredentialWith(nil) { credential, error in
				if error != nil {
					result(FlutterError.init(code: "200", message: error?.localizedDescription, details: nil))
				}
				if credential != nil {
					Auth.auth().signIn(with: credential!) { authResult, error in
						if error != nil {
							result(FlutterError.init(code: "100", message: error?.localizedDescription, details: nil))
						}
						// User is signed in.
						result("")
					}
				}
			}
			
		}catch let error as NSError {
			fatalError(error.localizedDescription)
		}
	}
	
	private func signInWithApple(arguments: [String: String], result: @escaping FlutterResult) {
		if #available(iOS 13, *) {
			self.result = result
			self.arguments = arguments
			self.startSignInWithAppleFlow()
		} else {
			fatalError("This is only available on iOS 13")
		}
	}
		
	@available(iOS 13, *)
	func startSignInWithAppleFlow() {
		do {
			let nonce = randomNonceString()
			let appleIDProvider = ASAuthorizationAppleIDProvider()
			let request = appleIDProvider.createRequest()
			request.requestedOperation = .operationLogin
			if let data = arguments!["scopes"]!.data(using: .utf8) {
				if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String]
				{
					request.requestedScopes = jsonArray.map({
						(scope) -> ASAuthorization.Scope in
						if(scope == "email") {return .email}
						else if(scope == "fullName") {return .fullName}
						else {fatalError("Unsupported scope " + scope)}
					})
				} else {
					print("Invalid scopes list")
				}
				
			} else {
				fatalError("Scopes not defined")
			}
			
			request.nonce = sha256(nonce)
			currentNonce = nonce
			let authorizationController = ASAuthorizationController(authorizationRequests: [request])
			authorizationController.delegate = self
			authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
			authorizationController.performRequests()
		} catch let error as NSError {
			fatalError(error.localizedDescription)
		}
	}
	
	@available(iOS 13, *)
	private func sha256(_ input: String) -> String {
		let inputData = Data(input.utf8)
		let hashedData = SHA256.hash(data: inputData)
		let hashString = hashedData.compactMap {
			return String(format: "%02x", $0)
		}.joined()
		
		return hashString
	}
	
	// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
	private func randomNonceString(length: Int = 32) -> String {
		precondition(length > 0)
		let charset: Array<Character> =
			Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
		var result = ""
		var remainingLength = length
		
		while remainingLength > 0 {
			let randoms: [UInt8] = (0 ..< 16).map { _ in
				var random: UInt8 = 0
				let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
				if errorCode != errSecSuccess {
					fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
				}
				return random
			}
			
			randoms.forEach { random in
				if length == 0 {
					return
				}
				
				if random < charset.count {
					result.append(charset[Int(random)])
					remainingLength -= 1
				}
			}
		}
		
		return result
	}
	
	@available(iOS 13.0, *)
	public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			guard let nonce = currentNonce else {
				fatalError("Invalid state: A login callback was received, but no login request was sent.")
			}
			guard let appleIDToken = appleIDCredential.identityToken else {
				fatalError("Invalid appleIDToken")
			}
			guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
				fatalError("Invalid idTokenString")
			}
			let credential = OAuthProvider.credential(withProviderID: "apple.com",
													  idToken: idTokenString,
													  rawNonce: nonce)
			Auth.auth().signIn(with: credential) { (authResult, error) in
				if (error != nil) {
					self.result!(FlutterError.init(code: "100", message: error?.localizedDescription, details: nil))
					return
				}
				// User is signed in.
				self.result!("")
			}
		}
	}
	
	@available(iOS 13.0, *)
	public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		self.result!(FlutterError.init(code: "200", message: error.localizedDescription, details: nil))
	}
	
	
}
