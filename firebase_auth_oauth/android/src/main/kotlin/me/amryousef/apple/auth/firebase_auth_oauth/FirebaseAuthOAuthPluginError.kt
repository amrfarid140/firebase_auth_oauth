package me.amryousef.apple.auth.firebase_auth_oauth

import io.flutter.plugin.common.MethodChannel.Result

sealed class FirebaseAuthOAuthPluginError {
    data class FirebaseAuthError(val exception: Exception) : FirebaseAuthOAuthPluginError()
    data class PlatformError(val exception: Exception) : FirebaseAuthOAuthPluginError()
    data class PluginError(val error: String) : FirebaseAuthOAuthPluginError()

    val code: String
        get() {
            return when (this) {
                is FirebaseAuthError -> "FirebaseAuthError"
                is PlatformError -> "PlatformError"
                is PluginError -> "PluginError"
            }
        }
}

fun FirebaseAuthOAuthPluginError.toResult(result: Result) {
    when (this) {
        is FirebaseAuthOAuthPluginError.FirebaseAuthError ->
            result.error(code, exception.localizedMessage, exception)
        is FirebaseAuthOAuthPluginError.PlatformError ->
            result.error(code, exception.localizedMessage, exception)
        is FirebaseAuthOAuthPluginError.PluginError ->
            result.error(code, error, null)
    }
}