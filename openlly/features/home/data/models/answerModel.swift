//
//  answerModel.swift
//  openlly
//
//  Created by Mobin on 26/12/24.
//


import Foundation

struct Answer: Codable {
    let id: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let answerTo: String
    var seen: Bool
    let question: Question

    mutating func updateSeen(_ seen: Bool) {
        self.seen = seen
    }
}
