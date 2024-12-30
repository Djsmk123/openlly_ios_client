//
//  messageLoadingView.swift
//  openlly
//
//  Created by Mobin on 27/12/24.
//


import SwiftUI

struct MessageTabLoadingView : View {
    var body: some View {
        List(0..<5, id: \.self) { _ in
                               HStack {
                                   Circle()
                                       .fill(Color.gray.opacity(0.3))
                                       .frame(width: 40, height: 40)
                                       .shimmering()

                                   VStack(alignment: .leading, spacing: 8) {
                                       Rectangle()
                                           .fill(Color.gray.opacity(0.3))
                                           .frame(height: 16)
                                           .cornerRadius(4)
                                           .shimmering()

                                       Rectangle()
                                           .fill(Color.gray.opacity(0.3))
                                           .frame(height: 12)
                                           .cornerRadius(4)
                                           .shimmering()
                                   }

                                   Spacer()
                               }
                               .padding(.vertical, 8)
                           }
                           .listStyle(PlainListStyle())
    }
}
