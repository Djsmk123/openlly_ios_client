//
//  shareService.swift
//  openlly
//
//  Created by Mobin on 30/12/24.
//

import Foundation
import UIKit

enum ShareError: Error {
    case instagramNotInstalled
    case instagramNotSupported
    case invalidArgs
    case unknown
}

struct InstaStoryShareArgs {
    var imagePath: String? = nil
    var videoPath: String? = nil
    var imagePathStickers: String? = nil
    var backgroundTopColor: String? = nil
    var backgroundBottomColor: String? = nil
    var attributionUrl: String? = nil
    var linkCaption: String? = nil

    func validate() -> Bool {
        // either image or video should be present
        return imagePath != nil || videoPath != nil
    }
}

class ShareService {
    let remoteService = FirebaseRemoteService.shared
    func shareToInstagramStory(args: InstaStoryShareArgs, completion: @escaping (Result<Bool, ShareError>) -> Void) {
        let appIDString = remoteService.remoteConfigModel?.facebookAppId
        if appIDString == nil {
            completion(.failure(ShareError.instagramNotSupported))
            return
        }
        if let urlScheme = URL(string: "instagram-stories://share?source_application=\(String(describing: appIDString))") {
            if UIApplication.shared.canOpenURL(urlScheme) {
                // Prepare pasteboard items
                var backgroundImage: UIImage?
                if !(args.imagePath == nil) {
                    backgroundImage = UIImage(contentsOfFile: args.imagePath!)
                }
                var videoBackground: Data?
                if !(args.videoPath == nil) {
                    let backgroundVideoUrl = URL(fileURLWithPath: args.videoPath!)
                    videoBackground = try? Data(contentsOf: backgroundVideoUrl)
                }
                var stickerImage: UIImage?
                if !(args.imagePathStickers == nil) {
                    stickerImage = UIImage(contentsOfFile: args.imagePathStickers!)
                }
                var backgroundTopColor: String?
                if !(args.backgroundTopColor == nil) {
                    backgroundTopColor = args.backgroundTopColor
                }
                var backgroundBottomColor: String?
                if !(args.backgroundBottomColor == nil) {
                    backgroundBottomColor = args.backgroundBottomColor
                }
                var attributionUrl: String?
                if !(args.attributionUrl == nil) {
                    attributionUrl = args.attributionUrl
                    Logger.logEvent("attributionUrl: \(String(describing: attributionUrl))")
                }
                var linkCaption: String?
                if !(args.linkCaption == nil) {
                    linkCaption = args.linkCaption
                    Logger.logEvent("linkCaption: \(String(describing: linkCaption))")
                }
                var items: [String: Any] = [:] // Correctly define as a dictionary

                if let attributionUrl = attributionUrl {
                    // Append attributionUrl
                    items["com.instagram.sharedSticker.linkURL"] = attributionUrl
                }
                if let linkCaption = linkCaption {
                    // Append linkCaption
                    items["com.instagram.sharedSticker.linkText"] = linkCaption
                }
                if let stickerImage = stickerImage {
                    // Append stickerImage
                    items["com.instagram.sharedSticker.stickerImage"] = stickerImage
                }
                if let videoBackground = videoBackground {
                    // Append videoBackground
                    items["com.instagram.sharedSticker.backgroundVideo"] = videoBackground
                }
                if let backgroundImage = backgroundImage {
                    // Append backgroundImage
                    items["com.instagram.sharedSticker.backgroundImage"] = backgroundImage
                }
                if let backgroundTopColor = backgroundTopColor {
                    // Append backgroundTopColor
                    items["com.instagram.sharedSticker.backgroundTopColor"] = backgroundTopColor
                }
                if let backgroundBottomColor = backgroundBottomColor {
                    // Append backgroundBottomColor
                    items["com.instagram.sharedSticker.backgroundBottomColor"] = backgroundBottomColor
                }

                // Convert to an array of dictionaries for the pasteboard
                let pasteboardItems: [[String: Any]] = [items]

                // let pasteboardItems = [
                //     // [
                //     //     "com.instagram.sharedSticker.linkURL" : attributionUrl ?? "",
                //     //     "com.instagram.sharedSticker.linkText" : linkCaption ?? "",
                //     //     "com.instagram.sharedSticker.stickerImage": stickerImage ?? "",
                //     //     "com.instagram.sharedSticker.backgroundVideo": videoBackground ?? "",
                //     //     "com.instagram.sharedSticker.backgroundImage": backgroundImage ?? "",
                //     //     "com.instagram.sharedSticker.backgroundTopColor": backgroundTopColor ?? "",
                //     //     "com.instagram.sharedSticker.backgroundBottomColor": backgroundBottomColor ?? "",
                //     // ]
                // ]

                // Set expiration date for the pasteboard items (e.g., 5 minutes)
                let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
                    .expirationDate: Date().addingTimeInterval(60 * 5), // 5 minutes
                ]

                // Set items to the pasteboard
                UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
                completion(.success(true))
            } else {
                completion(.failure(ShareError.instagramNotInstalled))
            }
        }
    }
}
