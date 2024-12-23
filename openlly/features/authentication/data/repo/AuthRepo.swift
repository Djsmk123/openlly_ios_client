//
//  AuthRepo.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//

import Foundation

protocol AuthRepo {
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AuthRepoImpl: AuthRepo {
    let networkService: APIClient
    let authRemoteSource : AuthRemoteSource
    
    init(networkService: APIClient) {
        self.networkService = networkService
        self.authRemoteSource = AuthRemoteSource(networkService: networkService)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authRemoteSource.login(email: email, password: password) { result in
            switch result {
            case .success(let res):
                UserDefaults.standard.set(res.token, forKey: "auth_token")
                completion(.success(()))
        
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authRemoteSource.signUp(email: email, password: password) { result in
            switch result {
            case .success(let res):
                UserDefaults.standard.set(res.token, forKey: "auth_token")
                completion(.success(()))
        
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
   
}


