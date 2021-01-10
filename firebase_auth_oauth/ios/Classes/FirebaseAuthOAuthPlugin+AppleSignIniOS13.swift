//
//  FirebaseAuthOAuthPlugin+iOS13.swift
//  firebase_auth_oauth
//
//  Created by Amr Yousef on 20/06/2020.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth


extension FirebaseAuthOAuthViewController: ASAuthorizationControllerDelegate {
	
	@available(iOS 13, *)
	func signInWithApple(arguments: [String: String]) {
		self.arguments = arguments
		self.startSignInWithAppleFlow()
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
						else if(scope == "fullName" || scope == "name") {return .fullName}
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
		return SHA256.hash(data: Data(input.utf8)).compactMap {
			return String(format: "%02x", $0)
		}.joined()
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
					finalizeResult(
						FirebaseAuthOAuthPluginError.PluginError(error: "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
					)
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
				self.finalizeResult(
					FirebaseAuthOAuthPluginError
						.PluginError(error: "Invalid state: A login callback was received, but no login request was sent.")
				)
				return
			}
			guard let appleIDToken = appleIDCredential.identityToken else {
			self.finalizeResult(
				FirebaseAuthOAuthPluginError
					.PluginError(error: "Invalid appleIDToken")
			)
			return
			}
			guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
				self.finalizeResult(
					FirebaseAuthOAuthPluginError
						.PluginError(error: "Invalid appleIDToken")
				)
				return
			}
			let credential = OAuthProvider.credential(withProviderID: "apple.com",
													  idToken: idTokenString,
													  rawNonce: nonce)
			self.consumeCredentials(credential)
		}
	}
	
	@available(iOS 13.0, *)
	public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		self.finalizeResult(FirebaseAuthOAuthPluginError.PlatformError(error: error))
	}
}
