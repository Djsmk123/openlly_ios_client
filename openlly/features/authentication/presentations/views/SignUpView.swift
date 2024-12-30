import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel() // Observe the ViewModel
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: primaryGradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                Spacer().frame(height: 50)

                // Title
                Text("Create Your Account")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 16)
                
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
                
                // Password Field with Show Password Button inside
                ZStack {
                    if viewModel.isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.blue)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.blue)
                    }
                    
                    // Show/Hide password icon inside the text field
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.isPasswordVisible.toggle()
                        }) {
                            Image(systemName: viewModel.isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 10)
                    }
                }
                .padding(.bottom, 20)
                
                // Confirm Password Field with Show Password Button inside
                ZStack {
                    if viewModel.isConfirmPasswordVisible {
                        TextField("Confirm Password", text: $viewModel.confirmPassword)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.blue)
                    } else {
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.blue)
                    }
                    
                    // Show/Hide password icon inside the text field
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: viewModel.isConfirmPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 10)
                    }
                }
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
            .padding(.bottom, 0) // Keep this as 0 to prevent shifting
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

#Preview {
    SignUpView(viewModel: SignUpViewModel())
}
