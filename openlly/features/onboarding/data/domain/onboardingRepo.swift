//
//  onboardingRepo.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//

import Foundation

protocol OnboardingRepo {
    func getUserNameList(completion: @escaping (Result<[String], Error>) -> Void)
    func validateUsername(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class OnboardingRepoImpl: OnboardingRepo {
    let networkService: APIClient
    let onboardingRemoteSource: OnboardingRemoteSource

    init(networkService: APIClient) {
        self.networkService = networkService
        onboardingRemoteSource = OnboardingRemoteSource(networkService: networkService)
    }

    func getUserNameList(completion: @escaping (Result<[String], Error>) -> Void) {
        onboardingRemoteSource.getUserNameList(completion: { result in
            switch result {
            case let .success(res):
                completion(.success(res))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

    func validateUsername(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        onboardingRemoteSource.validateUsername(username: username, completion: { result in
            switch result {
            case let .success(res):
                completion(.success(res))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
