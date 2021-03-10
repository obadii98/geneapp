package com.example.teams

import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import android.view.ViewTreeObserver
import android.app.ActivityManager
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.view.SurfaceView
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

//    private val CHANNEL = "poc.deeplink.flutter.dev/channel"
//    private var startString: String? = null
//    private val EVENTS = "poc.deeplink.flutter.dev/events"
//    private var linksReceiver: BroadcastReceiver? = null
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//
//        EventChannel(flutterEngine.dartExecutor, EVENTS).setStreamHandler(
//                object : EventChannel.StreamHandler {
//                    override fun onListen(args: Any?, events: EventSink) {
//                        linksReceiver = createChangeReceiver(events)
//                    }
//
//                    override fun onCancel(args: Any?) {
//                        linksReceiver = null
//                    }
//                }
//        )
//    }
//    override fun onNewIntent(intent: Intent) {
//        super.onNewIntent(intent)
//        if (intent.action === Intent.ACTION_VIEW) {
//            linksReceiver?.onReceive(this.applicationContext, intent)
//        }
//    }
//    fun createChangeReceiver(events: EventSink): BroadcastReceiver? {
//        return object : BroadcastReceiver() {
//            override fun onReceive(context: Context, intent: Intent) { // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW
//                val dataString = intent.dataString ?:
//                events.error("UNAVAILABLE", "Link unavailable", null)
//                events.success(dataString)
//            }
//        }
//    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        val intent = getIntent()
//        startString = intent.data?.toString()
        val flutter_native_splash = true
        var originalStatusBarColor = 0
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            originalStatusBarColor = window.statusBarColor
            window.statusBarColor = 0xffeaeaea.toInt()
        }
        val originalStatusBarColorFinal = originalStatusBarColor


        if (!setSecureSurfaceView()) {
            Log.e("MainActivity", "Could not secure the MainActivity!")
            // React as appropriate.
        }
        getWindow().addFlags(LayoutParams.FLAG_SECURE)
        getWindow().setFlags(LayoutParams.FLAG_SECURE,
                LayoutParams.FLAG_SECURE)
        SurfaceView(applicationContext).setSecure(true)
    }
    private fun setSecureSurfaceView(): Boolean {
        val content = findViewById<ViewGroup>(android.R.id.content)
        if (!isNonEmptyContainer(content)) {
            return false
        }
        val splashView = content.getChildAt(0)
        if (!isNonEmptyContainer(splashView)) {
            return false
        }
        val flutterView = (splashView as ViewGroup).getChildAt(0)
        if (!isNonEmptyContainer(flutterView)) {
            return false
        }
        val surfaceView = (flutterView as ViewGroup).getChildAt(0)
        if (surfaceView !is SurfaceView) {
            return false
        }
        surfaceView.setSecure(true)
        this.window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        return true
    }

    private fun isNonEmptyContainer(view: View): Boolean {
        if (view !is ViewGroup) {
            return false
        }
        if (view.childCount < 1) {
            return false
        }
        return true
    }
}