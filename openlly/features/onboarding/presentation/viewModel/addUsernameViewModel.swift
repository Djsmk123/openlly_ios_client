//
//  addUsernameViewModel.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//

import SwiftUI

class AddUsernameViewModel: ObservableObject {
    @Published var username = ""
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .error
    @Published  var aiSuggestions = [String]()  // For storing AI-generated usernames
    @Published  var isLoading = false           // To control loading state
    @Published  var buttonScale: CGFloat = 1.0  // To control button scale animation
    let networkService = APIClient()
    let onboardingRepo: OnboardingRepo
    let userRepo: ProfileRepo
    @Published var errorOccurred: Bool = false
    
    init() {
        self.onboardingRepo = OnboardingRepoImpl(networkService: networkService)
        self.userRepo = ProfileRepoImpl(networkService: networkService)
    }
    
    // Function to validate the username
    func validateUsername() -> Bool {
        if username.count < 3 {
            toastMessage = "Username must be at least 3 characters long."
            toastType = .error
            showToast = true
            return false
        } else if username.count > 10 {
            toastMessage = "Username must be no more than 10 characters long."
            toastType = .error
            showToast = true
            return false
        }
        
        
        return true
    }
    
    // Reset the toast after a short delay
    func resetToast() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showToast = false
        }
    }
    // Function to load more suggestions (simulating a network request)
    func loadMoreSuggestions() {
        self.isLoading = true
        //call onboarding repo
        onboardingRepo.getUserNameList(completion: {
            result in
            switch result {
            case .success(let usernames):
                self.aiSuggestions = usernames
                self.isLoading = false
                self.errorOccurred = false
            case .failure(let error):
                print("Error fetching AI-generated usernames: \(error)")
                self.errorOccurred = true
                self.isLoading = false
            }
        })
    }
    func submitUsername() {
        guard validateUsername() else { return }

        // Check if the username exists
        onboardingRepo.validateUsername(username: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let isUsernameExist):
                if isUsernameExist {
                    // Handle case where the username exists (e.g., show a message or take action)
                    return
                } else {
                    self.updateUsername()
                }
                
            case .failure(let error):
                self.handleError(error: error, defaultMessage: "Username validation failed")
            }
        }
    }

    private func updateUsername() {
        userRepo.updateUsername(username: self.username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.showToast(message: "Username updated successfully", type: .success)
                profileViewModel.user = user
                self.replaceRoot(with: HomeView())  
            case .failure(let error):
                self.handleError(error: error, defaultMessage: "Username update failed")
            }
        }
    }

    private func handleError(error: Error, defaultMessage: String) {
        if case APIError.customError(let message) = error {
            showToast(message: message, type: .error)
        } else {
            showToast(message: "\(defaultMessage): \(error.localizedDescription)", type: .error)
        }
    }

    private func showToast(message: String, type: ToastType) {
        self.toastMessage = message
        self.toastType = type
        self.showToast = true
        resetToast()
    }

    private func replaceRoot<T: View>(with view: T) {
        DispatchQueue.main.async {
            // Get the window scene
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            
            // Create a new hosting controller with the view
            let hostingController = UIHostingController(rootView: view)
            
            // Add a custom transition animation using UIView
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve, // You can use different options here
                              animations: {
                                  window.rootViewController = hostingController
                              },
                              completion: nil)
        }
    }


}
