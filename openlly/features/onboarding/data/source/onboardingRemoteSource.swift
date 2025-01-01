//
//  onboardingRemoteSource.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//

import Foundation

class OnboardingRemoteSource {
    private let networkService: APIClient

    init(networkService: APIClient) {
        self.networkService = networkService
    }

    // get user name list of String
    func getUserNameList(completion: @escaping (Result<[String], APIError>) -> Void) {
        networkService.request(endpoint: "username/getUsername", type: .get, completion: completion)
    }

    // validate username
    func validateUsername(username: String, completion: @escaping (Result<Bool, APIError>) -> Void) {
        var components = URLComponents(string: "username/validateUsername")!
        components.queryItems = [
            URLQueryItem(name: "username", value: username),
        ]
        networkService.request(endpoint: components.string!, type: .get, completion: completion)
    }
}
