import SwiftUI
import PhotosUI



struct MessageReplyView: View {
    let answer: Answer
    let onDismiss: () -> Void
    
    let gradientColors: [[Color]] = [
        primaryGradient,
        [Color(red: 45/255, green: 45/255, blue: 45/255), Color(red: 25/255, green: 25/255, blue: 25/255)],
        [Color(red: 68/255, green: 68/255, blue: 68/255), Color(red: 38/255, green: 38/255, blue: 38/255)],
        [Color(red: 92/255, green: 92/255, blue: 92/255), Color(red: 52/255, green: 52/255, blue: 52/255)]
    ]
    
    @State private var currentIndex = 0
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var toastType: ToastType = .error
    @State private var downloadingLoading: Bool = false
    private let imageSaver = ImageSaver()
    private let shareService = ShareService()

    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    impactGenerator.impactOccurred()
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 16)
                .padding(.top, 8)
            }
            
            Spacer()
            
            AnswerCardView(gradient: Gradient(colors: gradientColors[currentIndex]), answer: answer,showBranding: false)
            
            // Buttons
            HStack(spacing: 30) {
                // Change Gradient Button
                Button(action: {
                    impactGenerator.impactOccurred()
                    currentIndex = (currentIndex + 1) % gradientColors.count
                }) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: gradientColors[currentIndex]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 60, height: 60)
                        Image(systemName: "paintpalette")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Download Button
                Button(action: saveCardToGallery) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: gradientColors[currentIndex]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 60, height: 60)
                        Image(systemName: "arrow.down.to.line")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top, 20)
            Spacer()
            
            // Gradient Button with Haptic Feedback
            ButtonView(
                title: "Reply", isLoading: false,
                buttonStyle: .gradient,
                gradientColors: gradientColors[currentIndex],
                action: {
                    Task{
                        await shareBackgroundAndStickerImage()
                    }
                }
            ).cornerRadius(99)
                .padding(.horizontal,24)
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toast(
            message: toastMessage,
            type: toastType,
            position: .top,
            showIcon: false,
            isShowing: $showToast
        )
    }
    
    // Method to trigger toast with custom message and type
    private func showToastWithMessage(_ message: String, type: ToastType) {
        toastMessage = message
        toastType = type
        showToast = true
        
        // Hide the toast after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showToast = false
        }
    }
    
    private func saveCardToGallery() {
    impactGenerator.impactOccurred()

    if PHPhotoLibrary.authorizationStatus() == .authorized {
        downloadingLoading = true
        renderImageToGallery()

        
    } else {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                self.saveCardToGallery()
            } else {
                DispatchQueue.main.async {
                    self.showToastWithMessage("Please grant photo library access", type: .error)
                }
            }
        }
    }
        
 } 
 @MainActor
    func shareBackgroundAndStickerImage() async {
        
        
        // Download the image asynchronously
        do {
            
            // Pass the downloaded image to the QuestionCardShareView
            let questionView = AnswerCardView(gradient: Gradient(colors: gradientColors[currentIndex]), answer: answer,showBranding: true)
                .frame(width: 375, height: 600)
                .padding(.horizontal, 48)
            
            // Use ImageRenderer to render the view into a UIImage
            let renderer = ImageRenderer(content: questionView)
            
            // Set a high resolution scale
            renderer.scale = UIScreen.main.scale  // Adjust for higher resolution
            
            if let uiImage = renderer.uiImage {
                let imagePath = NSTemporaryDirectory() + UUID().uuidString + ".png"
                let imageURL = URL(fileURLWithPath: imagePath)
                
                // Save UIImage as a high-quality PNG
                if let data = uiImage.pngData() {
                    try data.write(to: imageURL)
                    
                    // Share the image
                    shareService.shareToInstagramStory(args: InstaStoryShareArgs(imagePathStickers: imageURL.path,attributionUrl : answer.question.urlValue, linkCaption: "openlly.netlify.app"), completion: { result in
                        switch result {
                        case .success(let success):
                            print("Successfully shared to Instagram Story: \(success)")
                        case .failure(let error):
                            print("Failed to share to Instagram Story: \(error.localizedDescription)")
                        }
                    })
                }
            }
        } catch {
            print("Failed to download the image: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func renderImageToGallery() {
        // Create the renderer for capturing the view as an image
        let renderer = ImageRenderer(content: AnswerCardView(gradient: Gradient(colors: gradientColors[currentIndex]), answer: answer,showBranding: true).frame(width: 375, height: 600))

        // Use the display scale for the current device
        renderer.scale = UIScreen.main.scale

        if let uiImage = renderer.uiImage {
            imageSaver.saveImageToGallery(image: uiImage) { success, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showToastWithMessage("Error saving image: \(error.localizedDescription)", type: .error)
                    } else {
                        self.showToastWithMessage("Saved to gallery", type: .success)
                    }
                    self.downloadingLoading = false
                }
            }
        }
    }
}

