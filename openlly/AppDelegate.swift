import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        print("AppDelegate: didFinishLaunchingWithOptions called")
        FirebaseApp.configure()
        return true
    }
}
