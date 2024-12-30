//
//  profileLocalSource.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//



import Foundation

class ProfileLocalSource{
    func getProfile() -> User? {
        if let data = UserDefaults.standard.data(forKey: "user"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }
    func saveProfile(user: User) {
        let data = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: "user")
    }
}
