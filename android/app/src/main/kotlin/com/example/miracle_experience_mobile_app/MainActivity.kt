package com.miracleexperience.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.SystemClock

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.miracleexperience.app/system_uptime"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSystemUptime") {
                // SystemClock.elapsedRealtime() returns milliseconds since boot
                // This is a monotonic clock that cannot be changed by user
                val uptime = SystemClock.elapsedRealtime()
                result.success(uptime)
            } else {
                result.notImplemented()
            }
        }
    }
}