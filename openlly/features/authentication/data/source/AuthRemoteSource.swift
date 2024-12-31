//
//  AuthRemoteSource.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//

import Foundation


class AuthRemoteSource{
    private let networkService: APIClient
    
    init(networkService: APIClient) {
        self.networkService = networkService
    }
    func sendEmailVerification( email : String,
        completion: @escaping (Result<Void, APIError>) -> Void) {
        networkService.request(endpoint: "auth/magic-link", type: .post, body: try? JSONEncoder().encode(["email": email]), completion: { (result: Result<VoidResponse, APIError>) in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })  
    }
    func validateEmailVerification(email : String,token : String,
        completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        networkService.request(endpoint: "auth/magic-link/verify", type: .post, body: try? JSONEncoder().encode(["email": email, "token": token]), completion: completion)
    }
}
