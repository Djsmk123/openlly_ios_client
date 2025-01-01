//
//  EmailVerificationLinkView.swift
//  openlly
//
//  Created by Mobin on 31/12/24.
//

import SwiftUI

// View Model for handling verification logic

struct EmailVerificationLinkView: View {
    @StateObject private var viewModel = EmailVerificationLinkViewModel()
    @EnvironmentObject var appState: AppState

    let token: String

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: primaryGradient),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                switch viewModel.verificationState {
                case .loading:
                    loadingView
                case .verified:
                    successView
                case let .error(message):
                    errorView(message: message)
                }

                Spacer()

                if case .error = viewModel.verificationState {
                    returnToLoginButton
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.verifyEmail(tokenString: token)
        }
        .onChange(of: viewModel.verificationState, perform: { newState in
            if case .verified = newState {
                // Handle successful verification
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if case .profileComplete = viewModel.userStatus {
                        appState.navigateToAuthenticatedState()
                    } else {
                        appState.navigateToUsernameUnavailableState()
                    }
                }
            }
        })
    }

    // Loading state view
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)

            Text("Verifying your email...")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }

    // Success state view
    private var successView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)

            Text("Email Verified!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("You'll be redirected shortly...")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
        }
    }

    // Error state view
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)

            Text("Verification Failed")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(message)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }

    // Return to login button
    private var returnToLoginButton: some View {
        Button(action: {
            appState.setEmailVerificationUrlRecieved(url: nil)
        }) {
            Text("Return to Login")
                .font(.body.weight(.semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(99)
        }
    }
}

#Preview {
    EmailVerificationLinkView(token: "")
}

extension EmailVerificationLinkViewModel.VerificationState: Equatable {
    static func == (lhs: EmailVerificationLinkViewModel.VerificationState, rhs: EmailVerificationLinkViewModel.VerificationState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.verified, .verified):
            return true
        case let (.error(lhsMessage), .error(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
