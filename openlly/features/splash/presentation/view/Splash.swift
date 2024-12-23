import SwiftUI

struct SplashView: View {
    @StateObject
    private var viewModel = SplashViewModel(repository: SplashRepositoryImpl())

    @State private var navigationPath = NavigationPath()
    

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: primaryGradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        Text("Openlly")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
            }
            .task {
                // Make the asynchronous check for authentication state
                 viewModel.checkAuth()
            }.onChange(of: viewModel.authState) { [weak viewModel] _ in
                            guard let viewModel = viewModel else { return }
                            switch viewModel.authState {
                            case .authenticated:
                                // Clear the stack before appending the "Home" destination
                                navigationPath = NavigationPath()
                                navigationPath.append("Home")
                            case .unauthenticated:
                                // Clear the stack before appending the "Login" destination
                                navigationPath = NavigationPath()
                                navigationPath.append("Login")
                            }
                        }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "Home":
                    LoginView() // Navigate to Home view
                case "Login":
                    LoginView() // Navigate to Login view
                default:
                    EmptyView() // Fallback case
                }
            }
        }
    }
}
