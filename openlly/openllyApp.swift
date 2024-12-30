//
//  openllyApp.swift
//  openlly
//
//  Created by Mobin on 19/12/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Ensure Firebase is configured first
        FirebaseApp.configure()

        return true
    }
}

@main
struct openllyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    

  

    var body: some Scene {
        WindowGroup {
            SplashView().onOpenURL(perform:{result in print("recived url",result)})
        }
        
    }
}
