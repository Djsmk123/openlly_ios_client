import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let height: CGFloat
    let width: CGFloat

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero) // A container to manage constraints
        let animationView = LottieAnimationView(name: animationName)
        
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit // Ensure the animation scales properly
        animationView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(animationView)

        // Apply constraints to the animation view
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: height),
            animationView.widthAnchor.constraint(equalToConstant: width),
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        animationView.play()
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed for static animations
    }
}
