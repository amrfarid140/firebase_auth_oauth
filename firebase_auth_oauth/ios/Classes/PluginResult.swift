//
//  PluginResult.swift
//  firebase_auth_oauth
//
//  Created by Amr Yousef on 20/06/2020.
//

enum PluginResult {
	case Success(data: Any)
	case error(error: FirebaseAuthOAuthPluginError)
}
