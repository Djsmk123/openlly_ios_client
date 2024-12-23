//
//  UserModel.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//

import Foundation

struct User: Decodable {

    let id: String
    let email: String
    let createdAt: String
    let profileImage: String    


    //parse createdAt
    var createdAtDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: createdAt) ?? Date()
    }   
    //toJson
    func toJson() -> [String: Any] {
        return ["id": id, "email": email, "createdAt": createdAt, "profileImage": profileImage]
    }   
}   
