//
//  UpdateProfilePictureView.swift
//  openlly
//
//  Created by Mobin on 26/12/24.
//

import PhotosUI
import SwiftUI

class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let onImagePicked: (Data?) -> Void
    private let onError: (String) -> Void

    init(onImagePicked: @escaping (Data?) -> Void, onError: @escaping (String) -> Void) {
        self.onImagePicked = onImagePicked
        self.onError = onError
    }

    func presentImagePicker(on viewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        viewController.present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            onError("Failed to process the selected image.")
            return
        }

        let imageData = selectedImage.jpegData(compressionQuality: 0.8)
        onImagePicked(imageData)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
