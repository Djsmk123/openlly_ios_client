//
//  DeleteAccountView.swift
//  openlly
//
//  Created by Mobin on 26/12/24.
//
import SwiftUI

struct DeleteAccountSection: View {
    @Binding var showDeleteAccountConfirmation: Bool
    
    var body: some View {
         Button(action: {
                showDeleteAccountConfirmation.toggle()
            }) {
                HStack {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
            }
            .confirmationDialog("Are you sure you want to delete your account?", isPresented: $showDeleteAccountConfirmation, titleVisibility: .visible) {
                Button("Delete Account", role: .destructive) {
                    // Delete account logic here
                    // Replace root view with LoginView
                    SettingsViewModel().replaceRootWithLoginView()
                }
                Button("Cancel", role: .cancel) {}
            }
    }
}
