//
//  AppState.swift
//  openlly
//
//  Created by Mobin on 31/12/24.
//
import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var navigationPath: NavigationPath = .init()
    @Published var authState: SplashStates = .unknown
    @Published var emailVerificationUrlRecieved: String?

    func handleDeepLink(_ url: URL) {
        Logger.logEvent("Deep link URL: \(url)")
        Logger.logEvent("Deep link URL Components: \(String(describing: URLComponents(url: url, resolvingAgainstBaseURL: false)))")
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
              let token = queryItems.first(where: { $0.name == "token" })?.value,
              let email = queryItems.first(where: { $0.name == "email" })?.value,
              authState == .unauthenticated || authState == .unknown
        else {
            Logger.logEvent("current state \(authState)")
            Logger.logEvent("Ignoring deep link navigation since app is not in unauthenticated state")
            return
        }
        let mergedString = "\(token)?email=\(email)"
        Logger.logEvent("Deep link merged string: \(mergedString)")
        setEmailVerificationUrlRecieved(url: mergedString)
    }

    func navigateToAuthenticatedState() {
        authState = .authenticated
        setEmailVerificationUrlRecieved(url: nil)
    }

    func navigateToUsernameUnavailableState() {
        authState = .usernameUnavailable
        setEmailVerificationUrlRecieved(url: nil)
    }

    func navigateToUnauthenticatedState() {
        authState = .unauthenticated
        setEmailVerificationUrlRecieved(url: nil)
    }

    func setEmailVerificationUrlRecieved(url: String?) {
        emailVerificationUrlRecieved = url
    }
}
