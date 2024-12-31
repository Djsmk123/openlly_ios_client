//
//  EmailVerificationLinkViewModel.swift
//  openlly
//
//  Created by Mobin on 31/12/24.
//
import SwiftUI

class EmailVerificationLinkViewModel: ObservableObject {
    @Published var verificationState: VerificationState = .loading
    @Published var userStatus: UserStatus = .unknown
    private let authRepo = AuthRepoImpl(networkService: APIClient())

    enum VerificationState {
        case loading
        case verified
        case error(String)
    }
    enum UserStatus{
        case profileComplete
        case missingUsername
        case unknown
    }
    
    func verifyEmail(tokenString: String) {
        verificationState = .loading
        //split string ?
        let token = tokenString.split(separator: "?")[0]
        let email = tokenString.split(separator: "?")[1].split(separator: "=")[1]
        if(token.isEmpty || email.isEmpty) {
            verificationState = .error("Invalid link, please check your email.")
            return
        }
        authRepo.validateEmailVerification(email: String(email), token: String(token), completion: { result in
           DispatchQueue.main.async {
                switch result {
            case .success(let user):
                self.verificationState = .verified
                profileViewModel.user = user
                //check if username is not empty or null
                    self.userStatus = user.username != nil && user.username != "null" ? .profileComplete : .missingUsername
            case .failure(let error):
                if case APIError.customError(let message) = error {
                    self.verificationState = .error(message)
                } else {
                    self.verificationState = .error("Link verification failed, please try again")
                }
            }
           }
        })

    }
}
