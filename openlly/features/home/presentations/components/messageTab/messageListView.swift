//
//  messageListView.swift
//  openlly
//

import SwiftUI

struct MessageListView: View {
    let answers: [Answer]
    let onTap: (_ index: Int) -> Void
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        List(answers.indices, id: \.self) { index in
            let message = answers[index]

            HStack {
                // Leading gradient avatar
                gradientAvatar(gradientColors: primaryGradient)
                    .overlay(
                        LottieView(animationName: "eyeEmoji", loopMode: .loop, height: 20, width: 20)
                    )

                VStack(alignment: .leading) {
                    // Display message content based on seen status
                    if message.seen {
                        Text(message.content)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    } else {
                        Text("New message")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(primaryGradient[1])
                    }

                    // Time ago
                    Text(timeAgo(from: message.createdAt))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Right arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            .onTapGesture {
                impactGenerator.impactOccurred()
                onTap(index) // Pass the index of the tapped message
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.white)
        .scrollContentBackground(.hidden)
    }

    // Gradient circle view for avatar
    func gradientAvatar(gradientColors: [Color]) -> some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 48, height: 48)
    }
}
