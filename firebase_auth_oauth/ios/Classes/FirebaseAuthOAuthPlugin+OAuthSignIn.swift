//
//  FirebaseAuthOAuthPlugin+OAuthSignIn.swift
//  firebase_auth_oauth
//
//  Created by Amr Yousef on 20/06/2020.
//

import FirebaseAuth

extension FirebaseAuthOAuthViewController {
	func oAuthSignIn(arguments: [String: String]) {
		guard let scopesString = arguments["scopes"] else {
			finalizeResult(
				FirebaseAuthOAuthPluginError
					.PluginError(error: "Scope cannot be null")
			)
			return
		}
	
		guard let data = scopesString.data(using: .utf8) else {
			finalizeResult(
				FirebaseAuthOAuthPluginError
					.PluginError(error: "Invalid scopes list")
			)
			return
		}
		
		guard let jsonArray = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String] else {
			finalizeResult(
				FirebaseAuthOAuthPluginError
					.PluginError(error: "Invalid scopes list")
			)
			return
		}
		authProvider?.scopes = jsonArray
		
		let parametersString = arguments["parameters"]
		
		if let data = parametersString?.data(using: .utf8) {
			if let jsonObject = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String, String>
			{
				authProvider?.customParameters = jsonObject
			}
		}
		
		authProvider?.getCredentialWith(nil) { credential, error in
			if let firebaseError = error {
				self.finalizeResult(
					FirebaseAuthOAuthPluginError
						.FirebaseAuthError(error: firebaseError)
				)
				return
			}
			
			if credential != nil {
				self.consumeCredentials(credential!)
			}
		}
	}
}
