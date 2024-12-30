import SwiftUI

struct QuestionCardShareView: View {
    let question: Question
    let image: UIImage
    
    var body: some View {
        ZStack {
            // Background: Vibrant blurred image
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 1080, height: 1920)
                .clipped()
                .blur(radius: 120)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
            
            VStack(spacing: 16) {
                Spacer() // Push content to the center
                
                // Card Section
                VStack {
                    // Gradient Header
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: question.gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: question.title == "Ask Me Anything!" ? 500 : 350) // Adjust height dynamically
                        .cornerRadius(40, corners: [.topLeft, .topRight])
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        
                        VStack(spacing: 16) {
                            // Avatar with Glow Effect
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [.white.opacity(0.8), .clear]),
                                            center: .center,
                                            startRadius: 10,
                                            endRadius: 60
                                        )
                                    )
                                    .frame(width: 130, height: 130)
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            }
                            
                            // Username
                            Text("@\(profileViewModel.user?.username ?? "")")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 2)
                            
                            // Question Title
                            Text(question.title)
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                    
                    // Content Section (direct text, no container)
                   if question.title != "Ask Me Anything!" {
                       Text(question.content)
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 64)
                        .padding(.vertical, 24)
                    }
                }
                .background(Color.white)
                .cornerRadius(40)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                // Call-to-Action (Link Section)
                HStack(spacing: 12) {
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                        
                    
                    Text("🔥 Add your link here")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.blue)
                        
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(
                    RoundedRectangle(cornerRadius: 99)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.bottom, 64)
                
                // Footer Text
                Text("✨ @Openlly - Be part of the hype! ✨")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .padding(.bottom, 64)
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: 1080, height: 1920)
    }
}
