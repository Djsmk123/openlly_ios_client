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
    @Published var aiSuggestions = [String]() // For storing AI-generated usernames
    @Published var isLoading = false // To control loading state
    @Published var buttonScale: CGFloat = 1.0 // To control button scale animation
    let networkService = APIClient()
    let onboardingRepo: OnboardingRepo
    let userRepo: ProfileRepo
    @Published var errorOccurred: Bool = false

    init() {
        onboardingRepo = OnboardingRepoImpl(networkService: networkService)
        userRepo = ProfileRepoImpl(networkService: networkService)
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
        isLoading = true
        // call onboarding repo
        onboardingRepo.getUserNameList(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(usernames):
                    self.aiSuggestions = usernames
                    self.isLoading = false
                    self.errorOccurred = false
                case let .failure(error):
                    print("Error fetching AI-generated usernames: \(error)")
                    self.errorOccurred = true
                    self.isLoading = false
                }
            }
        })
    }

    func submitUsername(
        onSuccess: @escaping () -> Void
    ) {
        guard validateUsername() else { return }

        // Check if the username exists
        onboardingRepo.validateUsername(username: username) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(isUsernameExist):
                    if isUsernameExist {
                        // Handle case where the username exists (e.g., show a message or take action)
                        return
                    } else {
                        self.updateUsername()
                    }
                    onSuccess()

                case let .failure(error):
                    self.handleError(error: error, defaultMessage: "Username validation failed")
                }
            }
        }
    }

    private func updateUsername() {
        userRepo.updateUsername(username: username) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(user):
                self.showToast(message: "Username updated successfully", type: .success)
                profileViewModel.user = user

            case let .failure(error):
                self.handleError(error: error, defaultMessage: "Username update failed")
            }
        }
    }

    private func handleError(error: Error, defaultMessage: String) {
        if case let APIError.customError(message) = error {
            showToast(message: message, type: .error)
        } else {
            showToast(message: "\(defaultMessage): \(error.localizedDescription)", type: .error)
        }
    }

    private func showToast(message: String, type: ToastType) {
        toastMessage = message
        toastType = type
        showToast = true
        resetToast()
    }
}
