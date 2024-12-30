import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel(repository: SplashRepositoryImpl())
    @State private var navigationPath = NavigationPath()
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .home:
                    HomeView()
                case .login:
                    LoginView()
                case .addUsername:
                    AddUsernameView()
                }
            }
        }
        .onAppear {
            print("SplashView: onAppear, checking auth state")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                viewModel.checkAuth()
                            }
                        }
            
        }
        .onChange(of: viewModel.authState, initial: viewModel.authState == .unknown, {
               switch viewModel.authState {
               case .authenticated:
                   print("SplashView: navigating to Home")
                   dismiss() // Dismiss splash view first
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                       replaceRoot(with: HomeView())
                   }
               case .unauthenticated:
                   print("SplashView: navigating to Login")
                   dismiss() // Dismiss splash view first
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                       replaceRoot(with: LoginView())
                   }
               case .unknown:
                   print("SplashView: initial state")
               case .usernameUnavailable:
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                       replaceRoot(with: AddUsernameView())
                   }
               }
        })
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
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        transition.subtype = .fromRight
        window.layer.add(transition, forKey: kCATransition)
    }
}

// Define navigation routes
enum Route {
    case home
    case login
    case addUsername
}
