//
//  SignUpView 2.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//


import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel() // Observe the ViewModel
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: primaryGradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Title
                Text("Create Your Account")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                // Subtitle
                Text("Join Openlly and connect anonymously!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 40)
                
                // Email Field
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .accentColor(.blue)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.bottom, 20)
                
                // Password Field
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .accentColor(.blue)
                    .padding(.bottom, 20)
                
                // Confirm Password Field
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .accentColor(.blue)
                    .padding(.bottom, 20)
                
                // Sign Up Button with animation
                ButtonView(
                    title: "Sign Up",
                    isLoading: viewModel.isLoading,
                    backgroundColor: viewModel.isButtonPressed ? Color.white.opacity(0.7) : Color.white,
                    textColor: .black,
                    centerTitle: true,
                    action: {
                        viewModel.handleSignUp() // Call viewModel's sign up method
                    }
                )
                
                Spacer()
                
                // Navigation to Login view
                NavigationLink(destination: LoginView()) {
                    Text("Already have an account? Log In")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .underline()
                        .padding(.top, 10)
                        
                        .accentColor(.red)
                }
            }
            .padding()
        }
        .toast(
            message: viewModel.toastMessage,
            type: viewModel.toastType,
            position: .top,
            showIcon: true,
            isShowing: $viewModel.showToast
        )
    }
}

#Preview {
    SignUpView(viewModel: SignUpViewModel())
}
