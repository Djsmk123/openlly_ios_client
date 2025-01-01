//
//  profileRepo.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//

import Foundation

protocol ProfileRepo {
    func getProfile(completion: @escaping (Result<User, Error>) -> Void)
    func updateUsername(username: String, completion: @escaping (Result<User, Error>) -> Void)
    // uploadProfileImage
    func uploadProfileImage(image: Data, completion: @escaping (Result<User, Error>) -> Void)
}

class ProfileRepoImpl: ProfileRepo {
    let networkService: APIClient
    let profileRemoteSource: ProfileRemoteSource
    let profileLocalSource: ProfileLocalSource

    init(networkService: APIClient) {
        self.networkService = networkService
        profileRemoteSource = ProfileRemoteSource(networkService: networkService)
        profileLocalSource = ProfileLocalSource()
    }

    func getProfile(completion: @escaping (Result<User, Error>) -> Void) {
        if networkService.isConnectedToInternet() {
            profileRemoteSource.getProfile(completion: { result in
                switch result {
                case let .success(res):
                    self.profileLocalSource.saveProfile(user: res)
                    completion(.success(res))
                case let .failure(error):
                    completion(.failure(error))
                }
            })
        } else {
            if let localUser = profileLocalSource.getProfile() {
                completion(.success(localUser))
            } else {
                completion(.failure(APIError.noInternetConnection))
            }
        }
    }

    func updateUsername(username: String, completion: @escaping (Result<User, Error>) -> Void) {
        profileRemoteSource.updateUsername(username: username) { result in
            switch result {
            case let .success(res):
                if let localUser = self.profileLocalSource.getProfile() {
                    let updatedUser = localUser.copy(username: res.username)
                    self.profileLocalSource.saveProfile(user: updatedUser)
                    completion(.success(updatedUser))
                } else {
                    completion(.failure(APIError.customError("Local profile not found")))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func uploadProfileImage(image: Data, completion: @escaping (Result<User, Error>) -> Void) {
        profileRemoteSource.uploadProfileImage(image: image) { result in
            switch result {
            case let .success(res):
                print("Profile Image uploaded successfully \(res)")
                self.profileLocalSource.saveProfile(user: res)
                completion(.success(res))
            case let .failure(error):
                print("Failed to upload profile image \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
