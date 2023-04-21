package co.altme.alt.me.altme

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity(), MethodChannel.MethodCallHandler {

    private val CHANNEL = "my_channel"
    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDeviceArch" -> {
                val arch = System.getProperty("os.arch")
                result.success(arch)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}