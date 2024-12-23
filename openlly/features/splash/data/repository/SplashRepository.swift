//
//  SplashRepository.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//
import Foundation

protocol SplashRepository {
    //check for auth
    func checkAuth() -> AuthState
}


class SplashRepositoryImpl: SplashRepository {
    func checkAuth() -> AuthState {
    //check for auth
        let token = UserDefaults.standard.string(forKey: "auth_token")
        return token != nil ? .authenticated : .unauthenticated
    }
}
