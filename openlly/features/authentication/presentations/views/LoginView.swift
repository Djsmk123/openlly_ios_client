import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: primaryGradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }

            VStack(spacing: 16) {
               
                Spacer().frame(height: 50)
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
                
                // Login Button
                ButtonView(
                    title: "Login",
                    isLoading: viewModel.isLoading,
                    backgroundColor: viewModel.isButtonPressed ? Color.white.opacity(0.7) : Color.white,
                    textColor: .black,
                    centerTitle: true,
                    action: {
                        viewModel.handleLogin() // Call viewModel's login method
                    }
                )

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
            .padding(.bottom, 0) // Keep this as 0 to prevent shifting
        }
        .ignoresSafeArea(.keyboard,edges: .bottom)
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
    LoginView().preferredColorScheme(.light)
}
