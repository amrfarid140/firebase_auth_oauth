import Flutter
import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

public class SwiftFirebaseAppleAuthPlugin: UIViewController, FlutterPlugin, ASAuthorizationControllerDelegate {
	
	public static func register(with registrar: FlutterPluginRegistrar) {
		let channel = FlutterMethodChannel(name: "me.amryousef.apple.auth/firebase_apple_auth", binaryMessenger: registrar.messenger())
		let instance = SwiftFirebaseAppleAuthPlugin()
		registrar.addMethodCallDelegate(instance, channel: channel)
	}
	
	private var currentNonce: String?
	private var result: FlutterResult?
	
	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		if #available(iOS 13, *) {
			self.result = result
			signIn()
		} else {
			fatalError("This is only available on iOS 13")
		}
		
	}
	
	@available(iOS 13, *)
	private func signIn() {
		startSignInWithAppleFlow()
	}
	
	@available(iOS 13, *)
	func startSignInWithAppleFlow() {
		let nonce = randomNonceString()
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedOperation = .operationLogin
		request.requestedScopes = [.email]
		request.nonce = sha256(nonce)
		currentNonce = nonce
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
		authorizationController.performRequests()
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
				print("Unable to fetch identity token")
				return
			}
			guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
				print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
				return
			}
			// Initialize a Firebase credential.
			let credential = OAuthProvider.credential(withProviderID: "apple.com",
													  idToken: idTokenString,
													  rawNonce: nonce)
			// Sign in with Firebase.
			Auth.auth().signIn(with: credential) { (authResult, error) in
				if (error != nil) {
					// Error. If error.code == .MissingOrInvalidNonce, make sure
					// you're sending the SHA256-hashed nonce as a hex string with
					// your request to Apple.
					print(error?.localizedDescription ?? "Error in firebase sign in")
					self.result!(FlutterError.init(code: "100", message: "Faild to sign in with Firebase", details: nil))
					return
				}
				self.result!("")
			}
		}
	}
	
	@available(iOS 13.0, *)
	public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		self.result!(FlutterError.init(code: "200", message: "Faild to sign in with Apple", details: nil))
		print("Sign in with Apple errored: \(error)")
	}
}
