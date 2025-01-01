import SwiftUI

struct AddUsernameView: View {
    @StateObject private var viewModel = AddUsernameViewModel() // ViewModel for managing UI state
    @FocusState private var isUsernameFocused: Bool // Focus state for username field
    @EnvironmentObject var appState: AppState

    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: primaryGradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .onTapGesture {
                    isUsernameFocused = false
                }

            VStack(spacing: 16) {
                Spacer()
                // Onboarding progress text
                welcomeSection
                // AI-generated username suggestions as chips
                suggestionSection

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
                Spacer()

                // Submit Button with simplified animation
                actionButton
            }
            .padding()
            .padding(.bottom, 0)
        }
        .toast(
            message: viewModel.toastMessage,
            type: viewModel.toastType,
            position: .top,
            isShowing: $viewModel.showToast
        )
    }

    private var suggestionSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if viewModel.isLoading {
                    // Skeleton loader for AI suggestions
                    ForEach(0 ..< 5, id: \.self) { _ in
                        SkeletonView()
                            .transition(.scale)
                    }
                } else {
                    ForEach(viewModel.aiSuggestions, id: \.self) { suggestion in
                        Button(action: {
                            self.viewModel.username = suggestion
                            feedbackGenerator.impactOccurred() // Haptic feedback on tap
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
    }

    private var welcomeSection: some View {
        VStack(spacing: 40) {
            Text("Welcome to Openlly")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)

            Text("Choose your username to proceed.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))

            usernameField
        }
        .transition(.opacity)
    }

    // Username input field
    private var usernameField: some View {
        TextField("Enter your username", text: $viewModel.username)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
            .foregroundColor(.white)
            .focused($isUsernameFocused)
            .autocapitalization(.none)
            .keyboardType(.default)
    }

    // Main action button to submit username
    private var actionButton: some View {
        Button(action: {
            guard !viewModel.username.isEmpty else { return }
            viewModel.submitUsername(onSuccess: {
                appState.navigateToAuthenticatedState()
            })
        }) {
            ZStack {
                Text("Submit Username")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.black)
                    .opacity(viewModel.isLoading ? 0 : 1)

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                viewModel.username.isEmpty ?
                    Color.white.opacity(0.4) :
                    Color.white
            )
            .cornerRadius(99)
        }
        .disabled(viewModel.username.isEmpty || viewModel.isLoading)
    }
}

// Skeleton Loader View with shimmer effect
struct SkeletonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.6))
            .frame(width: 120, height: 40)
            .shimmering() // You can create a shimmer effect for the skeleton loader here
    }
}

extension View {
    // Shimmer effect for skeleton loader
    func shimmering() -> some View {
        overlay(
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
