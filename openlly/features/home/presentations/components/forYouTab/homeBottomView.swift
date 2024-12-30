//
//  homeBottomView.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//
import SwiftUI

struct HomeBottomView: View{
    let question : Question
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    let shareService = ShareService()

    var body: some View{
        VStack{
            VStack{
                Text("Step 1: Copy your link")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.bottom, 4)

                
        
                Text(question.urlValue)
                    .font(.system(size: 8)).lineLimit(1)
                    .foregroundColor(Color.black.opacity(0.6))
                    .padding(.bottom, 4)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                GradientOutlineButton(
                    title: "Copy Link", action: {
                        UIPasteboard.general.string = question.urlValue
                        //haptic feedback
                        impactGenerator.impactOccurred()
                    },
                    gradient: question.gradientColors)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            .padding(.bottom,16)
             VStack{
                Text("Step 2: Share link on your story")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 8)
                    .foregroundColor(.black)
                 ButtonView(
                                title: "Share!",
                                isLoading: false,
                                buttonStyle: .gradient,
                                gradientColors: question.gradientColors,
                                action: {
                                    impactGenerator.impactOccurred()
                                    Task {
                                              await shareBackgroundAndStickerImage()
                                          }
                                
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 99))
                            .padding(.horizontal, 16)
                            
        
                
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            

        }
    }

   

    @MainActor
    func shareBackgroundAndStickerImage() async {
        let imageUrl = URL(string: profileViewModel.user?.avatarImage ?? "")!
    
    // Download the image asynchronously
    do {
        let (data, _) = try await URLSession.shared.data(from: imageUrl)
        if let downloadedImage = UIImage(data: data) {
            // Pass the downloaded image to the QuestionCardShareView
            let questionView = QuestionCardShareView(question: question, image: downloadedImage)
            
            // Use ImageRenderer to render the view into a UIImage
            let renderer = ImageRenderer(content: questionView)
            
            // Set a high resolution scale
            renderer.scale = UIScreen.main.scale * 1 // Adjust for higher resolution
            
            if let uiImage = renderer.uiImage {
                let imagePath = NSTemporaryDirectory() + UUID().uuidString + ".png"
                let imageURL = URL(fileURLWithPath: imagePath)
                
                // Save UIImage as a high-quality PNG
                if let data = uiImage.pngData() {
                    try data.write(to: imageURL)
                
                    
                    // Share the image
                    shareService.shareToInstagramStory(args: InstaStoryShareArgs(imagePath: imageURL.path,attributionUrl: question.urlValue,linkCaption: "openlly.netlify.app"), completion: { result in
                        switch result {
                        case .success(let success):
                            print("Successfully shared to Instagram Story: \(success)")
                        case .failure(let error):
                            print("Failed to share to Instagram Story: \(error.localizedDescription)")
                        }
                    })
                }
            }
        } else {
            print("Failed to create UIImage from downloaded data.")
        }
    } catch {
        print("Failed to download the image: \(error.localizedDescription)")
    }
}


    
}
// Helper function to ensure proper rendering of `AsyncImage`
@MainActor
private func renderImage(renderer: ImageRenderer<QuestionCardShareView>) async -> UIImage? {
    // Wait for the SwiftUI rendering system to ensure the `AsyncImage` has loaded
    try? await Task.sleep(nanoseconds: 500_000_000) // Wait for 0.5 seconds (adjust as needed)
    return renderer.uiImage
}

#Preview {
    HomeBottomView(question: Question(id: "1", title: "Confessions", content: "send me anonymous confessions", createdAt: "2023-01-01", updatedAt: "2023-01-01", gradient: ["#302b63", "#24243e"], url: "https://example.com/image1.jpg"))
}
