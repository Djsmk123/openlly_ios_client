import SwiftUI

class SplashViewModel: ObservableObject {
    @Published var authState: SplashStates = .unknown
    private var repository: SplashRepository
    private var profileRepo: ProfileRepo
    private var remoteService = FirebaseRemoteService.shared

    init(repository: SplashRepository) {
        self.repository = repository
        profileRepo = ProfileRepoImpl(networkService: APIClient())
        remoteService.fetchAndActivateRemoteConfig { [weak self] _ in
            self?.profileRepo = ProfileRepoImpl(networkService: APIClient())
        }
    }

    func checkAuth() {
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // wait 0.5 seconds
            let currentState = await checkAuthenticationState()

            DispatchQueue.main.async {
                self.authState = currentState
            }
        }
    }

    private func checkAuthenticationState() async -> SplashStates {
        let currentState = await repository.checkAuth()

        if currentState == .authenticated {
            return await fetchProfile()
        }

        return currentState
    }

    private func fetchProfile() async -> SplashStates {
        do {
            let profile = try await withCheckedThrowingContinuation { continuation in
                profileRepo.getProfile { result in
                    switch result {
                    case let .success(user):
                        profileViewModel.user = user
                        continuation.resume(returning: user)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            if let username = profile.username, username != "null" {
                return .authenticated
            } else {
                return .usernameUnavailable
            }

        } catch {
            return .unauthenticated
        }
    }
}
