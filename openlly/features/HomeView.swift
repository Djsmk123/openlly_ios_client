//
//  HomeView.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//
import SwiftUI


struct HomeView : View {
    @State private var showLogoutAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            Button(action: {
                self.showLogoutAlert = true
            }) {
                Text("Logout")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        // Logout logic goes here
                        // For demonstration purposes, navigate to Login screen
                        //delete token
                        UserDefaults.standard.removeObject(forKey: "auth_token")
                       
                        self.presentationMode.wrappedValue.dismiss()
                        //navigate to login
                        replaceRoot(with: LoginView())

                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    private func replaceRoot<T: View>(with view: T) {
            // Get the window scene
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            
            // Create a new navigation controller with the destination view
            let hostingController = UIHostingController(rootView: NavigationStack {
                view
            })
            
            // Replace the root view controller
            window.rootViewController = hostingController
            
            // Add animation
            UIView.transition(with: window,
                             duration: 0.3,
                             options: .transitionCrossDissolve,
                             animations: nil,
                             completion: nil)
        }

}
