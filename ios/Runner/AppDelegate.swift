import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_application: UIApplication,
                     didFinishLaunchingWithOption launchOptions:
                     [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
        FirebaseApp.configure()
        return true
    }
}
