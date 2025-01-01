//
//  dotView.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//
import SwiftUI

struct PageDots: View {
    let count: Int
    let activeIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< count, id: \.self) { index in
                Circle()
                    .fill(index == activeIndex ? Color.blue : Color.gray)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.top, 8)
    }
}
