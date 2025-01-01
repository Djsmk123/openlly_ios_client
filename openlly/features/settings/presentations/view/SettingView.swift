import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    var body: some View {
        NavigationView {
            List {
                ProfileSection(onTapProfile: {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let viewController = windowScene.windows.first?.rootViewController
                    {
                        viewModel.pickImage(from: viewController)
                    }
                }, avatarImage: profileViewModel.user?.avatarImage, localImage: viewModel.selectedImageData, isProfileLoading: viewModel.isProfileUploading)
                InformationSection()
                AccountSection(showLogoutConfirmation: $viewModel.showLogoutConfirmation, showDeleteAccountConfirmation: $viewModel.showDeleteAccountConfirmation)
            }
            .listStyle(GroupedListStyle())
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toast(
            message: viewModel.toastMessage,
            type: viewModel.toastType,
            position: .top,
            showIcon: false,
            isShowing: $viewModel.showToast
        )
        .preferredColorScheme(.light) // Force light theme
    }
}

struct ProfileSection: View {
    let onTapProfile: () -> Void
    let avatarImage: String?
    let localImage: Data?
    let isProfileLoading: Bool

    var body: some View {
        Section(header: Text("Profile")) {
            HStack {
                if let localImage = localImage {
                    Image(uiImage: UIImage(data: localImage)!)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        }
                        .overlay {
                            if isProfileLoading {
                                ProgressView()
                                    .frame(width: 44, height: 44)
                            }
                        }
                } else if let avatarImage = avatarImage, let url = URL(string: avatarImage) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            }
                            .overlay {
                                if isProfileLoading {
                                    ProgressView()
                                        .frame(width: 44, height: 44)
                                }
                            }
                    } placeholder: {
                        if isProfileLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                        }
                    }
                }

                Text(profileViewModel.user?.username ?? "")
                    .font(.body)
            }
            .padding(.vertical, 10)

            Button(action: {
                onTapProfile()
            }) {
                Text("Update Profile Picture")
                    .font(.body)
            }
        }
    }
}

struct AccountSection: View {
    @Binding var showLogoutConfirmation: Bool
    @Binding var showDeleteAccountConfirmation: Bool
    var body: some View {
        Section(header: Text("Account")) {
            LogoutSection(showLogoutConfirmation: $showLogoutConfirmation)
            DeleteAccountSection(showDeleteAccountConfirmation: $showDeleteAccountConfirmation)
        }
    }
}
