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

    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        networkService.request(endpoint: "auth/login", type: .post, body: try? JSONEncoder().encode(["email": email, "password": password]), completion: completion)
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        networkService.request(endpoint: "auth/signup", type: .post, body: try? JSONEncoder().encode(["email": email, "password": password]), completion: completion)
    }
    
}
