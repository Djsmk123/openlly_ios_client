//
//  profileRemoteSource.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//

import Foundation

class ProfileRemoteSource {
    private let networkService: APIClient

    init(networkService: APIClient) {
        self.networkService = networkService
    }

    func getProfile(completion: @escaping (Result<User, APIError>) -> Void) {
        networkService.request(endpoint: "user", type: .get, completion: completion)
    }

    func updateUsername(username: String, completion: @escaping (Result<User, APIError>) -> Void) {
        networkService.request(endpoint: "user/updateUsername", type: .patch, body: try? JSONEncoder().encode(["username": username]), completion: completion)
    }

    // make post request with formdata
    func uploadProfileImage(image: Data, completion: @escaping (Result<User, APIError>) -> Void) {
        let fileData = ["file": image]
        // form data empty
        let formData: [String: Any] = [:]
        networkService.request(
            endpoint: "user/uploadProfileImg",
            type: .post,
            isMultipart: true,
            formData: formData,
            fileData: fileData,
            completion: completion
        )
    }
}
