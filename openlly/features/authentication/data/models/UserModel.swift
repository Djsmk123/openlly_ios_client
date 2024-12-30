//
//  UserModel.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//

import Foundation

struct User: Codable {

    let id: String
    let email: String
    let createdAt: String
    let profileImg: String?
    let username: String?

    var createdAtDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: createdAt) ?? Date()
    }

    var avatarImage: String {
        return profileImg ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgee_ioFQrKoyiV3tnY77MLsPeiD15SGydSQ&s"
    }

    func hasDefaultAvatarImage() -> Bool {
        return avatarImage == "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgee_ioFQrKoyiV3tnY77MLsPeiD15SGydSQ&s"
    }

    func copy(with id: String? = nil, email: String? = nil, createdAt: String? = nil, profileImg: String? = nil, username: String? = nil) -> User {
        return User(
            id: id ?? self.id,
            email: email ?? self.email,
            createdAt: createdAt ?? self.createdAt,
            profileImg: profileImg ?? self.profileImg,
            username: username ?? self.username
        )
    }
}
