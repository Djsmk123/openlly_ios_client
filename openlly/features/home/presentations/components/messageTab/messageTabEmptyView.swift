//
//  messageTabEmptyView.swift
//  openlly
//
//  Created by Mobin on 27/12/24.
//


import SwiftUI

struct MessageTabEmptyView : View {
    var body: some View {
        // Empty State
        VStack {
            Text("No messages")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Text("You don't have any messages yet. Try asking a question or answering a question to start a conversation.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}
