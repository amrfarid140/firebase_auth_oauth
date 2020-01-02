package me.amryousef.apple.auth.firebase_apple_auth

import android.app.Activity
import androidx.annotation.NonNull
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.OAuthProvider
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
class FirebaseAppleAuthPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "me.amryousef.apple.auth/firebase_apple_auth")
        channel.setMethodCallHandler(this)
    }

    companion object {
        @Suppress("unused")
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "me.amryousef.apple.auth/firebase_apple_auth")
            channel.setMethodCallHandler(FirebaseAppleAuthPlugin().apply { activity = registrar.activity() })
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val provider = OAuthProvider.newBuilder("apple.com")
                .setScopes(listOf("email"))
                .build()
        activity?.let {
            val auth = FirebaseAuth.getInstance()
            val pending = auth.pendingAuthResult
            @Suppress("IfThenToElvis")
            if (pending != null) {
                pending.addOnSuccessListener {
                    result.success("")
                }.addOnFailureListener {
                    result.error("100", "Pending auth failed", null)
                }
            } else {
                auth.startActivityForSignInWithProvider(it, provider).addOnSuccessListener {
                    result.success("")
                }.addOnFailureListener {
                    result.error("200", "auth failed", null)
                }
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
