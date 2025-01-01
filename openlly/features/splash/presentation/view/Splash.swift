import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = SplashViewModel(repository: SplashRepositoryImpl())

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: primaryGradient),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Text("Openlly")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .scaleEffect(viewModel.authState == .unknown ? 1.5 : 1)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.authState)
                )
        }
        .onAppear {
            viewModel.checkAuth()
        }
        .onChange(of: viewModel.authState) { newState in
            switch newState {
            case .authenticated:
                appState.navigateToAuthenticatedState()
            case .unauthenticated:
                appState.navigateToUnauthenticatedState()
            case .usernameUnavailable:
                appState.navigateToUsernameUnavailableState()
            case .unknown:
                break
            }
        }
    }
}

enum Route: Hashable {
    case home
    case login
    case addUsername
    case emailVerificationLink(token: String)
    case emailVerification
}
