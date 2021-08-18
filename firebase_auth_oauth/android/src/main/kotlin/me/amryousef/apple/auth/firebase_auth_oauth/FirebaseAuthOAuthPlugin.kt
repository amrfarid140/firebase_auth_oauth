package me.amryousef.apple.auth.firebase_auth_oauth

import android.app.Activity
import androidx.annotation.NonNull
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.OAuthProvider
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.OAuthCredential
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** FirebaseAppleAuthPlugin */
class FirebaseAuthOAuthPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "me.amryousef.apple.auth/firebase_auth_oauth"
        )
        channel.setMethodCallHandler(this)
    }

    companion object {
        private const val CREATE_USER_METHOD = "signInOAuth"
        private const val LINK_USER_METHOD = "linkWithOAuth"

        @Suppress("unused", "deprecation")
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel =
                MethodChannel(registrar.messenger(), "me.amryousef.apple.auth/firebase_auth_oauth")
            channel.setMethodCallHandler(FirebaseAuthOAuthPlugin().apply {
                activity = registrar.activity()
            })
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val providerBuilder =
            call.argument<String>("provider")?.let { OAuthProvider.newBuilder(it) }
        if (providerBuilder == null) {
            FirebaseAuthOAuthPluginError
                .PluginError("Provider argument cannot be null")
                .toResult(result)
            return
        }
        val gson = Gson()
        if (call.argument<String>("scopes") == null) {
            FirebaseAuthOAuthPluginError
                .PluginError("Scope cannot be null")
                .toResult(result)
            return
        }
        call.argument<String>("scopes")?.let {
            providerBuilder.setScopes(gson.fromJson(it, object : TypeToken<List<String>>() {}.type))
        }
        call.argument<String>("parameters")?.let {
            providerBuilder.addCustomParameters(
                gson.fromJson<Map<String, String>>(
                    it,
                    object : TypeToken<Map<String, String>>() {}.type
                )
            )
        }
        val provider = providerBuilder.build()
        activity?.let {
            val auth = call.argument<String>("app")?.let { appName ->
                FirebaseAuth.getInstance(FirebaseApp.getInstance(appName))
            } ?: FirebaseAuth.getInstance()
            val pending = auth.pendingAuthResult
            pending?.addOnSuccessListener {
                result.success("")
            }?.addOnFailureListener { error ->
                FirebaseAuthOAuthPluginError
                    .FirebaseAuthError(error)
                    .toResult(result)
            } ?: run {
                val task = call.method.toSignInTask(provider, auth, result)
                task.addOnSuccessListener(
                    fun (authResult: AuthResult) {
                        val credential = authResult.getCredential()
                        if (credential is OAuthCredential) {
                            result.success(mapOf(
                                "providerId" to authResult.getCredential()?.getProvider(),
                                "accessToken" to credential.getAccessToken(),
                                "idToken" to credential.getIdToken(),
                                "secret" to credential.getSecret()
                            ))
                        } else {
                            result.success(mapOf(
                                "providerId" to authResult.getCredential()?.getProvider()
                            ))
                        }
                    }
                ).addOnFailureListener { error ->
                    FirebaseAuthOAuthPluginError
                        .FirebaseAuthError(error)
                        .toResult(result)
                }
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    private fun String.toSignInTask(
        provider: OAuthProvider,
        auth: FirebaseAuth,
        result: Result
    ) = activity?.let {
        when (this) {
            LINK_USER_METHOD -> {
                val user = auth.currentUser
                if (user == null) {
                    FirebaseAuthOAuthPluginError.PluginError(
                        ""
                    ).toResult(result)
                }
                user!!.startActivityForLinkWithProvider(it, provider)
            }
            CREATE_USER_METHOD -> {
                auth.startActivityForSignInWithProvider(it, provider)
            }
            else -> {
                FirebaseAuthOAuthPluginError.PluginError("Unknown method called")
                com.google.android.gms.tasks.Tasks.forCanceled()
            }
        }
    } ?: com.google.android.gms.tasks.Tasks.forCanceled()
}
