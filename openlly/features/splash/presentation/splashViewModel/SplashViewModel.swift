//
//  SplashViewModel.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//

import Foundation

class SplashViewModel: ObservableObject{
    @Published
    var authState: AuthState = .unauthenticated 

    private let repository: SplashRepository
    
    init(repository: SplashRepository) {
        self.repository = repository
    }
    
    func checkAuth() {
        DispatchQueue.global().async{
            let state = self.repository.checkAuth()
            DispatchQueue.main.async {
              self.authState = state
            }
            
        }
    }
    
}
