//
//  LogoutView.swift
//  openlly
//
//  Created by Mobin on 26/12/24.
//

import SwiftUI

struct LogoutSection: View {
    @Binding var showLogoutConfirmation: Bool
    
    var body: some View {
         Button(action: {
                showLogoutConfirmation.toggle()
            }) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.red)
                    Text("Log Out")
                        .foregroundColor(.red)
                }
            }
            .confirmationDialog("Are you sure you want to log out?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                Button("Log Out", role: .destructive) {
                    // Replace root view with LoginView
                    //auth_token delete from UserDefaults   
                    UserDefaults.standard.removeObject(forKey: "auth_token")
                    SettingsViewModel().replaceRootWithLoginView()
                }
                Button("Cancel", role: .cancel) {
                    
                }
            }
       
    }
}