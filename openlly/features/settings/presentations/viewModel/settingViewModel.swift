//
//  settingModel.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//
import UIKit
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var selectedImageData: Data?
    @Published var isProfileUploading = false
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .success
    @Published var showLogoutConfirmation = false
    @Published var showDeleteAccountConfirmation = false


   private var imagePickerCoordinator: ImagePickerCoordinator?

    func pickImage(from viewController: UIViewController) {
        let coordinator = ImagePickerCoordinator(onImagePicked: { [weak self] imageData in
            self?.selectedImageData = imageData
            self?.uploadProfileImage()
        }, onError: { [weak self] errorMessage in
            self?.showErrorToast(message: errorMessage)
        })
        
        imagePickerCoordinator = coordinator
        coordinator.presentImagePicker(on: viewController)
    }

    func uploadProfileImage() {
        guard selectedImageData != nil else {
            showErrorToast(message: "No image data available for upload.")
            return
        }

        self.isProfileUploading = true  

        // Simulate an upload process
        print("Uploading profile image...")
        profileViewModel.uploadProfileImage(image: self.selectedImageData!) { [weak self] result in
            switch result {
            case .success(_):
                self?.isProfileUploading = false
                self?.selectedImageData = nil
                self?.showSuccessToast(message: "Profile image uploaded successfully.") 
                print("Profile image uploaded successfully.")
            case .failure(let error):
                self?.showErrorToast(message: error.localizedDescription)
                self?.isProfileUploading = false
                print("Profile image upload failed: \(error.localizedDescription)")
            }
        }
    }

    func replaceRootWithLoginView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let loginView = LoginView() // Replace with actual LoginView
            let loginViewController = UIHostingController(rootView: loginView)
            window.rootViewController = loginViewController
        }
    }
     private func showSuccessToast(message: String) {
        self.toastMessage = message
        self.toastType = .success
        withAnimation {
            self.showToast = true
        }
        self.autoHideToast()
    }
    
    private func showErrorToast(message: String) {
        self.toastMessage = message
        self.toastType = .error
        withAnimation {
            self.showToast = true
        }
        self.autoHideToast()
    }
    
    private func autoHideToast() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showToast = false
            }
        }
    }
}


