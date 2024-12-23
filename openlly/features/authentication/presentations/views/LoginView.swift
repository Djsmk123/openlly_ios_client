import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isButtonPressed = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: ToastType = .error
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: primaryGradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
          
            VStack(spacing: 20) {
                // Title
                Text("Welcome to Openlly")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                // Subtitle
                Text("Anonymously connect and share your thoughts.")
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
                
                // Login Button
                Button(
                    
                    action: {
                    isButtonPressed = true
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isButtonPressed = false
                        isLoading = false
                        if email.isEmpty || password.isEmpty {
                            toastMessage = "Please fill in both fields"
                            toastType = .error
                            withAnimation {
                                showToast = true
                            }
                            // Auto-hide toast after 3 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showToast = false
                                }
                            }
                        } else {
                            // Simulating successful login
                            toastMessage = "Successfully logged in!"
                            toastType = .success
                            withAnimation {
                                showToast = true
                            }
                            // Auto-hide toast after 3 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showToast = false
                                }
                            }
                        }
                    }
                    }) {
                        
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isButtonPressed ? Color.white.opacity(0.7) : Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .font(.title3)
                        .scaleEffect(isButtonPressed ? 0.95 : 1)
                        .shadow(radius: 10)
                        .padding(.top, 20)
                        .overlay(
                            isLoading ? ProgressView() : nil
                        )
                    }
                Spacer()
                
                // Sign-up Navigation
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.white)
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

#Preview {
    LoginView().preferredColorScheme(.dark)
}
