//
//  SplashRepository.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//
import Foundation

protocol SplashRepository {
    //check for auth
    func checkAuth() async -> SplashStates
}


class SplashRepositoryImpl: SplashRepository {

    func checkAuth() async -> SplashStates {
    //check for auth
        let token = UserDefaults.standard.string(forKey: "auth_token")
        return token != nil ? .authenticated : .unauthenticated
    }
}
