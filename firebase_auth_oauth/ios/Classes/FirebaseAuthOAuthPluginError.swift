//
//  FirebaseAuthOAuthPluginError.swift
//  firebase_auth_oauth
//
//  Created by Amr Yousef on 20/06/2020.
//

enum FirebaseAuthOAuthPluginError: Error {
	case FirebaseAuthError(error: Error)
	case PluginError(error: String)
	case PlatformError(error: Error)
	
	var code: String {
		switch self {
		case .FirebaseAuthError:
			return "FirebaseAuthError"
		case .PluginError:
			return "PluginError"
		case .PlatformError:
			return "PlatformError"
		}
	}
}

extension FirebaseAuthOAuthPluginError {
	func flutterError() -> FlutterError {
		switch self {
		case .FirebaseAuthError(let error):
			return FlutterError(code: code, message: error.localizedDescription, details: nil)
		case .PlatformError(let error):
			return FlutterError(code: code, message: error.localizedDescription, details: nil)
		case .PluginError(let error):
			return FlutterError(code: code, message: error, details: nil)
		}
	}
}
