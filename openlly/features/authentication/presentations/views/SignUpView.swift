import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isButtonPressed = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: ToastType = .error
    
    // Email validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Validation logic
    private func validateFields() -> (isValid: Bool, message: String) {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return (false, "Please fill in all fields")
        }
        
        if !isValidEmail(email) {
            return (false, "Please enter a valid email address")
        }
        
        if password.count < 6 {
            return (false, "Password must be at least 6 characters long")
        }
        
        if password != confirmPassword {
            return (false, "Passwords do not match")
        }
        
        return (true, "Account created successfully!")
    }
    
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
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .accentColor(.blue)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.bottom, 20)
                
                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .accentColor(.blue)
                    .padding(.bottom, 20)
                
                // Confirm Password Field
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .accentColor(.blue)
                    .padding(.bottom, 20)
                
                // Sign Up Button with animation
                Button(action: {
                    isButtonPressed = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isButtonPressed = false
                        
                        // Validate fields
                        let validation = validateFields()
                        toastType = validation.isValid ? .success : .error
                        toastMessage = validation.message
                        
                        withAnimation {
                            showToast = true
                        }
                        
                        // Auto-hide toast after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showToast = false
                            }
                        }
                        
                        // If validation passed, proceed with sign up
                        if validation.isValid {
                            // TODO: Implement sign up functionality
                            print("Signing up...")
                        }
                    }
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isButtonPressed ? Color.blue.opacity(0.7) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.title3)
                        .scaleEffect(isButtonPressed ? 0.95 : 1)
                        .shadow(radius: 10)
                        .padding(.top, 20)
                }
                
                Spacer()
                
                // Navigation to Login view
                NavigationLink(destination: LoginView()) {
                    Text("Already have an account? Log In")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                        .underline()
                        .padding(.top, 10)
                }
            }
            .padding()
        }
        .toast(
            message: toastMessage,
            type: toastType,
            position: .top,
            showIcon: true,
            isShowing: $showToast
        )
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView()
                .preferredColorScheme(.light)
          
        }
    }
}
