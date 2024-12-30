import SwiftUI

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isButtonPressed: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var toastType: ToastType = .error
    @Published var isLoading: Bool = false
    @Published var isPasswordVisible: Bool = false // Change the access level
    @Published var isConfirmPasswordVisible: Bool = false // Same here for confirm password

    private let authRepo = AuthRepoImpl(networkService: APIClient())

    func handleSignUp() {
        isButtonPressed = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isButtonPressed = false

            let validation = self.validateFields()

            self.toastType = validation.isValid ? .success : .error
            self.toastMessage = validation.message

            withAnimation {
                self.showToast = true
            }

            self.autoHideToast()

            if validation.isValid {
                self.isLoading = true

                // Ensure the network call happens asynchronously
                self.authRepo.signUp(email: self.email, password: self.password) { result in
                    // Make sure UI updates happen on the main thread
                    DispatchQueue.main.async {
                        self.isLoading = false

                        switch result {
                        case .success(let user):
                            DispatchQueue.main.async {
                                self.showSuccessToast(message: "Account created successfully!")
                                profileViewModel.user = user
                                self.replaceRoot(with: AddUsernameView())  // Navigate to HomeView
                            }
                        case .failure(let error):
                            if case APIError.customError(let message) = error {
                                self.showErrorToast(message: message)
                            } else {
                                self.showErrorToast(message: "Sign-up failed: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }

    private func validateFields() -> (isValid: Bool, message: String) {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return (false, "Please fill in all fields")
        }

        if !isValidEmail(email) {
            return (false, "Please enter a valid email address")
        }

        if password.count < 6 {
            return (false, "Password must be at least 6 characters long")
        }

        if password != confirmPassword {
            return (false, "Passwords do not match")
        }

        return (true, "Account created successfully!")
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
