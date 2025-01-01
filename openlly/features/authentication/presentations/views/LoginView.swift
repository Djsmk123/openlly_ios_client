import SwiftUI

// View Model for handling email verification logic

struct LoginView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.emailVerificationUrlRecieved != nil {
                EmailVerificationLinkView(token: appState.emailVerificationUrlRecieved!)
            } else {
                EmailVerificationView()
            }
        }
    }
}

struct EmailVerificationView: View {
    @StateObject private var viewModel = EmailVerificationViewModel()
    @FocusState private var isEmailFocused: Bool
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: primaryGradient),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .onTapGesture {
                    isEmailFocused = false
                }

            VStack(spacing: 16) {
                Spacer().frame(height: 50)

                if !viewModel.isMagicLinkSent {
                    welcomeSection
                } else {
                    verificationSection
                }

                Spacer()

                if !viewModel.isMagicLinkSent {
                    actionButton
                    termsSection
                }
            }
            .padding()
            .padding(.bottom, 0)
        }
        .toast(message: viewModel.toastMessage,
               type: viewModel.toastStyle,
               isShowing: $viewModel.showToast)
    }

    // Welcome section with title and subtitle
    private var welcomeSection: some View {
        VStack(spacing: 40) {
            Text("Welcome to Openlly")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)

            Text("Enter your email to receive a magic link and log in.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))

            emailField
        }
        .transition(.opacity)
    }

    // Email input field
    private var emailField: some View {
        TextField("Email", text: $viewModel.email)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
            .foregroundColor(.white)
            .focused($isEmailFocused)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
    }

    // Verification message and controls
    private var verificationSection: some View {
        VStack(spacing: 10) {
            Spacer()
            Text("A magic link has been sent to your email. Please check your inbox to log in.")
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(12)
            Spacer()

            if viewModel.countdown > 0 {
                Text("You can resend the magic link in \(viewModel.countdown) seconds.")
                    .font(.body)
                    .foregroundColor(.white)
            }

            if viewModel.canResend {
                Button("Resend Link") {
                    viewModel.resendMagicLink()
                }
                .font(.body.weight(.bold))
                .foregroundColor(.white)
                .underline()
            }

            Button("Edit Email") {
                viewModel.resetState()
            }
            .font(.body)
            .foregroundColor(.white)
            .underline()
        }
        .transition(.opacity)
    }

    // Main action button
    private var actionButton: some View {
        Button(action: {
            guard !viewModel.email.isEmpty else { return }
            viewModel.sendMagicLink(resent: false)
        }) {
            ZStack {
                Text("Getting Started")
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
                viewModel.email.isEmpty ?
                    Color.white.opacity(0.4) :
                    Color.white
            )
            .cornerRadius(99)
        }
        .disabled(viewModel.email.isEmpty || viewModel.isLoading)
    }

    // Terms and conditions section
    private var termsSection: some View {
        VStack(spacing: 4) {
            Text("By getting started, you accept our")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))

            HStack(spacing: 2) {
                Button("Terms & Conditions") {
                    // Handle terms action
                }
                .font(.caption.weight(.bold))
                .foregroundColor(.white)
                .underline()

                Text("and")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                Button("Privacy Policy") {
                    // Handle privacy action
                }
                .font(.caption.weight(.bold))
                .foregroundColor(.white)
                .underline()
            }
        }
    }
}

#Preview {
    LoginView()
}
