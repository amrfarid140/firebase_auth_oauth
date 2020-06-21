package me.amryousef.apple.auth.firebase_auth_oauth

import android.app.Activity
import androidx.annotation.NonNull
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.OAuthProvider
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
@Suppress("DEPRECATION")
class FirebaseAuthOAuthPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "me.amryousef.apple.auth/firebase_auth_oauth")
        channel.setMethodCallHandler(this)
    }

    companion object {
        @Suppress("unused")
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "me.amryousef.apple.auth/firebase_auth_oauth")
            channel.setMethodCallHandler(FirebaseAuthOAuthPlugin().apply { activity = registrar.activity() })
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val providerBuilder = call.argument<String>("provider")?.let { OAuthProvider.newBuilder(it) }
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
                            object : TypeToken<Map<String, String>>() {}.type)
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
            } ?: auth.startActivityForSignInWithProvider(it, provider).addOnSuccessListener {
                result.success("")
            }.addOnFailureListener { error ->
                FirebaseAuthOAuthPluginError
                        .FirebaseAuthError(error)
                        .toResult(result)
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}
