package com.example.app

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import android.app.ActivityManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.vital/vitals"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getThermalState" -> result.success(getThermalState())
                "getBatteryLevel" -> result.success(getBatteryLevel())
                "getMemoryUsage" -> result.success(getMemoryUsage())
                "getConnectivityStatus" -> result.success(getConnectivityStatus())
                "getDeviceId" -> result.success(getAndroidId())
                else -> result.notImplemented()
            }
        }
    }

    private fun getAndroidId(): String {
        return android.provider.Settings.Secure.getString(contentResolver, android.provider.Settings.Secure.ANDROID_ID) ?: "unknown_android"
    }

    private fun getThermalState(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            val status = powerManager.currentThermalStatus
            // Mapping: 0: Normal, 1: Light, 2: Moderate, 3: Severe, etc.
            // Our app expects: 0: Nominal, 1: Fair, 2: Serious, 3: Critical
            when {
                status <= PowerManager.THERMAL_STATUS_NONE -> 0
                status <= PowerManager.THERMAL_STATUS_LIGHT -> 1
                status <= PowerManager.THERMAL_STATUS_MODERATE -> 2
                else -> 3
            }
        } else {
            0 // Nominal for older versions
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private fun getMemoryUsage(): Double {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        
        val totalMemory = memoryInfo.totalMem.toDouble()
        val availableMemory = memoryInfo.availMem.toDouble()
        val usedMemory = totalMemory - availableMemory
        
        return (usedMemory / totalMemory) * 100
    }

    private fun getConnectivityStatus(): Boolean {
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network = connectivityManager.activeNetwork ?: return false
            val activeNetwork = connectivityManager.getNetworkCapabilities(network) ?: return false
            return activeNetwork.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
        } else {
            val networkInfo = connectivityManager.activeNetworkInfo
            return networkInfo != null && networkInfo.isConnected
        }
    }
}
