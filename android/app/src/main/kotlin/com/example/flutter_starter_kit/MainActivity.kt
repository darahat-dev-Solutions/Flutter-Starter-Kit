package com.example.flutter_starter_kit

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.stripe.android.PaymentConfiguration

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize Stripe with publishable key from Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "stripe_config")
            .setMethodCallHandler { call, result ->
                if (call.method == "setPublishableKey") {
                    val publishableKey = call.argument<String>("publishableKey")
                    if (publishableKey != null) {
                        PaymentConfiguration.init(applicationContext, publishableKey)
                        result.success(true)
                    } else {
                        result.error("INVALID_KEY", "Publishable key is null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}