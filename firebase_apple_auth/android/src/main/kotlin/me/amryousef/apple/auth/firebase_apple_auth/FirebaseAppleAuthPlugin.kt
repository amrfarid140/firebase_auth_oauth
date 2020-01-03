package me.amryousef.apple.auth.firebase_apple_auth

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
        val providerBuilder = OAuthProvider.newBuilder(call.argument<String>("provider")!!)
        val gson = Gson()
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
            @Suppress("IfThenToElvis")
            if (pending != null) {
                pending.addOnSuccessListener {
                    result.success("")
                }.addOnFailureListener { error ->
                    result.error("100", error.localizedMessage, null)
                }
            } else {
                auth.startActivityForSignInWithProvider(it, provider).addOnSuccessListener {
                    result.success("")
                }.addOnFailureListener { error ->
                    result.error("200", error.localizedMessage, null)
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
