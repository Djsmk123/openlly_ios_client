//
//  AuthRepo.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//

import Foundation

protocol AuthRepo {
    func sendEmailVerification(email : String,
        completion: @escaping (Result<Void, Error>) -> Void)
    func validateEmailVerification(email : String,token : String,
        completion: @escaping (Result<User, Error>) -> Void)
}

class AuthRepoImpl: AuthRepo {
  
    
    let networkService: APIClient
    let authRemoteSource : AuthRemoteSource
    
    init(networkService: APIClient) {
        self.networkService = networkService
        self.authRemoteSource = AuthRemoteSource(networkService: networkService)
    }

    func sendEmailVerification(email : String,
                               completion: @escaping (Result<Void, Error>) -> Void) {
        authRemoteSource.sendEmailVerification(
            email: email,
            completion: { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    func validateEmailVerification(email : String,token : String,
                                   completion: @escaping (Result<User, Error>) -> Void) {
        authRemoteSource.validateEmailVerification(
            email: email,
            token: token,
            completion: { result in
                switch result {
                case .success(let res):
                    UserDefaults.standard.set(res.token, forKey: "auth_token")
                    completion(.success(res.user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
   
}


