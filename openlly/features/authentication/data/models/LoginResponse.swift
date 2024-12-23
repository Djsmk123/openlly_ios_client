//
//  LoginResponse.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//


import Foundation


struct LoginResponse: Decodable {
    let token: String
    let user: User
}
