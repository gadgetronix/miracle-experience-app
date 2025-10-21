import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let uptimeChannel = FlutterMethodChannel(name: "com.miracleexperience.app/system_uptime",
                                              binaryMessenger: controller.binaryMessenger)
    
    uptimeChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      if call.method == "getSystemUptime" {
        // ProcessInfo.processInfo.systemUptime returns seconds since boot
        // Convert to milliseconds for consistency with Android
        let uptime = ProcessInfo.processInfo.systemUptime
        let uptimeMs = Int64(uptime * 1000)
        result(uptimeMs)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
