import UIKit
import Flutter
import workmanager
import MachO

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        WorkmanagerPlugin.setPluginRegistrantCallback { registry in
            GeneratedPluginRegistrant.register(with: registry)
        }
        
        // Create a method channel
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let myChannel = FlutterMethodChannel(name: "my_channel", binaryMessenger: controller.binaryMessenger)
        
        // Set up the method channel handler
        myChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getDeviceArch" {
                let info = NXGetLocalArchInfo()
                let response =  NSString(utf8String: (info?.pointee.description)!)!
                result(response)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        WorkmanagerPlugin.registerTask(withIdentifier: "getPassBaseStatusBackground")
        UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*1))
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
