import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isButtonPressed: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var toastType: ToastType = .error
    @Published var isLoading: Bool = false
    
    private var authRepo: AuthRepo = AuthRepoImpl(networkService: APIClient())
    
    // Action to handle login
    func handleLogin() {
        // Ensure isButtonPressed is updated on the main thread
        DispatchQueue.main.async {
            self.isButtonPressed = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Ensure the updates happen on the main thread
            DispatchQueue.main.async {
                self.isButtonPressed = false
                
                guard !self.email.isEmpty, !self.password.isEmpty else {
                    self.showErrorToast(message: "Please fill in both fields")
                    return
                }
                
                self.isLoading = true
            }
            if(self.email.isEmpty || self.password.isEmpty){    
                self.showErrorToast(message: "Please fill in both fields")
                return
            }
            
            // Call the login method from the repository
            self.authRepo.login(email: self.email, password: self.password) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                switch result {
                case .success(let user):
                    DispatchQueue.main.async { 
                        self?.showSuccessToast(message: "Login successful!")
                        //check if user has username  
                        let hasUsername = user.username != nil  && user.username != "null" 
                        profileViewModel.user = user
 
                        if(hasUsername){
                            self?.replaceRoot(with: HomeView())
                        }else{
                            self?.replaceRoot(with: AddUsernameView())
                        }  
                    
                    }
                    
                    case .failure(let error):
                        if case APIError.customError(let message) = error {
                            self?.showErrorToast(message: message)
                        }
                    else {
                        self?.showErrorToast(message: "Login failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func showSuccessToast(message: String) {
        self.toastMessage = message
        self.toastType = .success
        withAnimation {
            self.showToast = true
        }
        self.autoHideToast()
    }
    
    private func showErrorToast(message: String) {
        self.toastMessage = message
        self.toastType = .error
        withAnimation {
            self.showToast = true
        }
        self.autoHideToast()
    }
    
    private func autoHideToast() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showToast = false
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
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            transition.subtype = .fromRight
            window.layer.add(transition, forKey: kCATransition)
        }

    

}
