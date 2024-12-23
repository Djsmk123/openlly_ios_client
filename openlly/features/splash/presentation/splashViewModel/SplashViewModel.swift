import SwiftUI
class SplashViewModel: ObservableObject {
    @Published var authState: AuthState = .unknown
    private var repository: SplashRepository

    init(repository: SplashRepository) {
        self.repository = repository
    }

    func checkAuth() {
        // Assume some asynchronous work to check authentication status
        DispatchQueue.global().async {
            // Simulating network delay
       
            
            // Assuming a simple condition for the example
            let isAuthenticated = self.repository.checkAuth() // Change this based on actual logic
            
            DispatchQueue.main.async {
                self.authState = isAuthenticated
            }
        }
    }
}
