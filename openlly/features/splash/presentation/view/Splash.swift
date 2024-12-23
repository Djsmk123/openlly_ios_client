import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel(repository: SplashRepositoryImpl())
    
    var body: some View {
        // Remove NavigationStack from here - it should be at a higher level
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
        .onAppear {
            print("SplashView: onAppear, checking auth state")
            viewModel.checkAuth()
        }
        .onChange(of: viewModel.authState) { authState in
            switch authState {
            case .authenticated:
                print("SplashView: navigating to Home")
                // Replace root view with HomeView
                replaceRoot(with: HomeView())
            case .unauthenticated:
                print("SplashView: navigating to Login")
                // Replace root view with LoginView
                replaceRoot(with: LoginView())
            case .unknown:
                print("SplashView: initial state")
            }
        }
    }
    
    private func replaceRoot<T: View>(with view: T) {
        // Get the window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return
        }
        
        // Create a new navigation controller with the destination view
        let hostingController = UIHostingController(rootView: NavigationStack {
            view
        })
        
        // Replace the root view controller
        window.rootViewController = hostingController
        
        // Add animation
        UIView.transition(with: window,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: nil,
                         completion: nil)
    }
}
