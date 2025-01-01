import SwiftUI

struct AnswerCardView: View {
    let gradient: Gradient
    let answer: Answer
    let showBranding: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Gradient container
            ZStack {
                LinearGradient(
                    gradient: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .frame(height: 100)

                VStack {
                    Text(answer.question.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 5)
                }
            }

            // Content container
            VStack {
                Text(answer.content)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            // bottom padding

            if showBranding {
                HStack {
                    // "Send me more messages" link with URL
                    Link("\(answer.question.urlValue)", destination: URL(string: answer.question.urlValue)!)
                        .font(.system(size: 8, weight: .regular))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .leading) // Left-aligned

                    // Branding text "@Openlly"
                    Text("@Openlly")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing) // Right-aligned
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .center) // Center-aligned
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .background(Color.white)
        .cornerRadius(32)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 24)
    }
}
