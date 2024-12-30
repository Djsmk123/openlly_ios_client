//
//  profileViewModel.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//


import Foundation
class ProfileViewModel {
 
    @Published var user: User?
    @Published var error: Error?
    
    private let profileRepo: ProfileRepo
    init(profileRepo: ProfileRepo = ProfileRepoImpl(networkService: APIClient())) {
        self.profileRepo = profileRepo
    }
    
    func fetchProfile() {
        profileRepo.getProfile { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.error = error
            }
        }
    }
    //assign profile
    func assignProfile(user: User) {
        self.user = user
    }
    func uploadProfileImage(image: Data, completion: @escaping (Result<User, Error>) -> Void) {
        profileRepo.uploadProfileImage(image: image) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
  

   

    
}

let profileViewModel = ProfileViewModel()


