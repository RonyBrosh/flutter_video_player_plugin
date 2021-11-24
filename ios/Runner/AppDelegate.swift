import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let reducedMotionChannel = FlutterMethodChannel(name: "ronybrosh.video_player/isReducedMotionEnabled",
                                                 binaryMessenger: controller.binaryMessenger)
    reducedMotionChannel.setMethodCallHandler({
        [weak self](call: FlutterMethodCall, result: FlutterResult) -> Void in
        guard call.method == "isReducedMotionEnabled" else {
           result(FlutterMethodNotImplemented)
           return
        }
        self?.getIsReducedMotionEnabled(result: result)
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func getIsReducedMotionEnabled(result: FlutterResult) {
        result(UIAccessibility.isReduceMotionEnabled)
    }
}
