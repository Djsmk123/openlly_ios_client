import SwiftUI

enum ButtonStyleType {
    case filled, outline, gradient
}

struct ButtonView: View {
    // Properties with default values
    var title: String
    var isLoading: Bool
    var backgroundColor: Color = .blue
    var textColor: Color = .white
    var prefixIcon: Image? = nil
    var suffixIcon: Image? = nil
    var centerTitle: Bool = true
    var buttonStyle: ButtonStyleType = .filled // Default is filled
    var gradientColors: [Color] = [.blue, .green] // Default gradient colors
    var action: () -> Void
    
    @State private var isButtonPressed = false
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Button(action: {
            isButtonPressed = true
            impactGenerator.impactOccurred()
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isButtonPressed = false
            }
        }) {
            HStack
            {
                if let prefixIcon = prefixIcon {
                    prefixIcon
                        .foregroundColor(textColor)
                        .padding(.leading)
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .frame(maxWidth: .infinity)
                        .opacity(isLoading ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isLoading)
                    Spacer()
                } else if centerTitle {
                    Text(title)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                        .font(.title3)
                        .opacity(isLoading ? 0 : 1) // Hide title during loading
                        .animation(.easeInOut(duration: 0.3), value: isLoading)
                }
                
                if let suffixIcon = suffixIcon {
                    suffixIcon
                        .foregroundColor(textColor)
                        .padding(.trailing)
                }
            }
            .padding()
            .background(background(for: buttonStyle))
            .cornerRadius(10)
            .shadow(radius: 10)
            .scaleEffect(isButtonPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.3), value: isButtonPressed)
        }
        .disabled(isLoading) // Disable button when loading
    }
    
    // Helper function to determine the background based on the button style
    private func background(for style: ButtonStyleType) -> some View {
        switch style {
        case .filled:
            return AnyView(backgroundColor)
        case .outline:
            return AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(backgroundColor, lineWidth: 2)
            )
        case .gradient:
            return AnyView(
                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(10)
            )
        }
    }
}
struct GradientOutlineButton: View {
    var title: String
    var action: () -> Void
    var gradient : [Color]

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "link")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(gradient.first)
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(gradient.first)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 99)
                    .strokeBorder( // Outline with gradient
                        LinearGradient(
                            gradient: Gradient(colors: gradient),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2 // Border thickness
                    )
            )
        }
    }
}


struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ButtonView(
                title: "Filled Button",
                isLoading: true,
                action: {
                    print("Filled Button tapped")
                }
            )
            .frame(height: 50)
            
            ButtonView(
                title: "Outline Button",
                isLoading: false,
                buttonStyle: .outline,
                action: {
                    print("Outline Button tapped")
                }
            )
            .frame(height: 50)
            
            ButtonView(
                title: "Gradient Button",
                isLoading: false,
                buttonStyle: .gradient,
                gradientColors: [.purple, .orange],
                action: {
                    print("Gradient Button tapped")
                }
            )
            .frame(height: 50)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

