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
     
        return .authenticated
        
    }
}
