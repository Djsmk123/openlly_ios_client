import SwiftUI

@main
struct OpenllyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState() // Central app state

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.navigationPath) {
                Group {
                    switch appState.authState {
                    case .unknown:
                        SplashView()
                            .environmentObject(appState)
                    case .unauthenticated:
                        LoginView()
                            .environmentObject(appState)
                    case .authenticated:
                        HomeView()
                            .environmentObject(appState)
                    case .usernameUnavailable:
                        AddUsernameView()
                            .environmentObject(appState)
                    }
                }
                .onOpenURL { url in
                    appState.handleDeepLink(url)
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .emailVerification:
                        EmailVerificationView()
                    case .emailVerificationLink(let token):
                        EmailVerificationLinkView(token: token)
                    default:
                        EmptyView() // No other navigation directly
                    }
                }
            }
        }
    }
}


