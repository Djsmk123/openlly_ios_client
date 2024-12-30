//
//  messageTabErrorState.swift
//  openlly
//
//  Created by Mobin on 27/12/24.
//

import SwiftUI

struct MessageTabErrorState: View {
    let onTapRetry: () -> Void
    var body: some View {

                           VStack {
                               Text("Something went wrong")
                                   .font(.title3)
                                   .fontWeight(.semibold)
                                   .foregroundColor(.red)
                                   .padding(.bottom,16)
                               
                               Button(action: onTapRetry) {
                                   Text("Retry")
                                       .font(.body)
                                       .fontWeight(.bold)
                                       .foregroundColor(.white)
                                       .padding()
                                       .background(Color.blue)
                                       .cornerRadius(8)
                               }
                           }
                           .padding()
    }
}

