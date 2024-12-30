//
//  imageSaver.swift
//  openlly
//
//  Created by Mobin on 27/12/24.
//

import Photos
import UIKit

class ImageSaver: NSObject {
    var completionHandler: ((Bool, Error?) -> Void)?

    @objc func saveImageToGallery(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        self.completionHandler = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(handleImageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func handleImageSaveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            completionHandler?(false, error)
        } else {
            completionHandler?(true, nil)
        }
    }
}
