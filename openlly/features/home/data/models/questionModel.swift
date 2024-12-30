//
//  questionModel.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//

import SwiftUI

struct Question: Codable {
    let id: String
    let title: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let gradient: [String]
    let url: String?

    var urlValue: String {
        return url ?? ""
    }

    var gradientColors: [Color] {
        return gradient.hexToColor()
    }
}

extension Array where Element == String {
    func hexToColor() -> [Color] {
        return self.compactMap { Color(hexString: $0) }
    }
}

extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
