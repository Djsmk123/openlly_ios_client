import SwiftUI

struct QuestionCard: View {
    let question: Question
    let cardWidth: CGFloat // Pass the width as a parameter
    let onTap: (Int) -> Void
    let userAvatar: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.gray, lineWidth: 0.2)
                )
                .frame(width: cardWidth, height: 200)

            VStack(spacing: 0) {
                // Gradient container
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: question.gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(32, corners: [.topLeft, .topRight]) // Only round the top corners
                    .frame(height: 120)

                    VStack {
                        // Circle avatar
                        AsyncImage(url: URL(string: userAvatar)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(.top, 10)

                        Text(question.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 5)
                    }
                }

                // Content container
                VStack {
                    Text(question.content)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 20)
            }
            .frame(width: cardWidth, height: 200)
        }
        .onTapGesture {
            // Handle tap gesture
        }
    }
}

extension View {
    // Helper modifier to round specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
