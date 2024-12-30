import SwiftUI

struct AddUsernameView: View {
    @StateObject private var viewModel = AddUsernameViewModel() // Use ViewModel for toast handling
  
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        ZStack {
            // Background gradient with reduced animation
            LinearGradient(gradient: Gradient(colors: primaryGradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .animation(.linear(duration: 3).repeatForever(autoreverses: true), value: UUID()) // Consider reducing this animation duration if needed

            VStack(spacing: 16) {
                // Onboarding progress text with reduced animation complexity
                VStack {
                    Text("Last Step")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(1.5)
                        .textCase(.uppercase)
                        .opacity(viewModel.isLoading ? 0 : 1)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.isLoading) // Reduced animation duration

                    Text("Choose Username")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(-0.5)
                        .padding(.bottom, 40)
                        .scaleEffect(viewModel.isLoading ? 0.95 : 1.0) // Slight scale effect
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewModel.isLoading) // Slightly simplified spring animation
                }

                // Username input field with focus animation
                TextField("Enter your username", text: $viewModel.username)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .accentColor(.black)
                    .autocapitalization(.none)
                    .padding(.bottom, 20)
                    .scaleEffect(viewModel.isLoading ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)

                // AI-generated username suggestions as chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if viewModel.isLoading {
                            // Skeleton loader for AI suggestions
                            ForEach(0..<5, id: \.self) { _ in
                                SkeletonView()
                                    .transition(.scale)
                            }
                        } else {
                            ForEach(viewModel.aiSuggestions, id: \.self) { suggestion in
                                Button(action: {
                                    self.viewModel.username = suggestion
                                    //haptic feedback
                                    feedbackGenerator.impactOccurred()
                                }) {
                                    Text(suggestion)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .foregroundColor(.black)
                                        .font(.system(size: 16, weight: .medium))
                                        .opacity(viewModel.isLoading ? 0.5 : 1.0)
                                        .scaleEffect(viewModel.isLoading ? 0.95 : 1.0)
                                        .animation(.spring(), value: viewModel.isLoading)
                                }
                                .padding(.trailing, 8)
                                .transition(.move(edge: .leading))
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    .onAppear {
                        withAnimation {
                            viewModel.loadMoreSuggestions()
                        }
                    }
                }

                // Dice button to load more suggestions with subtle scale effect
                Button(action: {
                    feedbackGenerator.impactOccurred()
                    viewModel.loadMoreSuggestions()
                }) {
                    Image(systemName: "die.face.5.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(1))
                        .padding(20)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .shadow(radius: 8)
                        .scaleEffect(viewModel.buttonScale)
                        .rotationEffect(.degrees(viewModel.buttonScale == 1.1 ? 10 : 0))
                        .animation(.easeInOut(duration: 0.3), value: viewModel.buttonScale)
                }
                .padding(.bottom, 20)

                // Submit Button with simplified animation
                ButtonView(
                    title: "Next",
                    isLoading: false,
                    backgroundColor: Color.white,
                    textColor: .black,
                    centerTitle: true,
                    action: viewModel.submitUsername
                )
                .scaleEffect(viewModel.isLoading ? 0.95 : 1.0)
                .animation(.spring(), value: viewModel.isLoading)
            }
            .padding()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toast(
            message: viewModel.toastMessage,
            type: viewModel.toastType,
            position: .top,
            showIcon: false,
            isShowing: $viewModel.showToast
        )
    }
}


// Skeleton Loader View with shimmer effect
struct SkeletonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.6))
            .frame(width: 120, height: 40)
            .shimmering()  // You can create a shimmer effect for the skeleton loader here
    }
}

extension View {
    // Shimmer effect for skeleton loader
    func shimmering() -> some View {
        self.overlay(
            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.2), Color.white.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .rotationEffect(.degrees(70))
                .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: UUID())
        )
        .mask(self)
    }
}

#Preview {
    AddUsernameView()
}
