//
//  toast.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//

import SwiftUI

// Toast type enum
enum ToastType {
    case success
    case error
    case info
    case warning
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .success: return Color.green.opacity(0.9)
        case .error: return Color.red.opacity(0.9)
        case .info: return Color.blue.opacity(0.9)
        case .warning: return Color.orange.opacity(0.9)
        }
    }
}

// Toast position enum
enum ToastPosition {
    case top
    case bottom
}

struct Toast: View {
    let message: String
    let type: ToastType
    let position: ToastPosition
    let showIcon: Bool
    var customBackgroundColor: Color?
    @Binding var isShowing: Bool
    
    // Default parameter initializer
    init(
        message: String,
        type: ToastType = .info,
        position: ToastPosition = .bottom,
        showIcon: Bool = true,
        customBackgroundColor: Color? = nil,
        isShowing: Binding<Bool>
    ) {
        self.message = message
        self.type = type
        self.position = position
        self.showIcon = showIcon
        self.customBackgroundColor = customBackgroundColor
        self._isShowing = isShowing
    }
    
    var body: some View {
        GeometryReader { geometry in
            if isShowing {
                VStack {
                    if position == .top {
                        toastView
                        Spacer()
                    } else {
                        Spacer()
                        toastView
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, position == .bottom ? 20 : 0)
                .padding(.top, position == .top ? 20 : 0)
                .transition(.move(edge: position == .top ? .top : .bottom))
                .animation(.spring(), value: isShowing)
            }
        }
    }
    
    private var toastView: some View {
        HStack(spacing: 12) {
            if showIcon {
                Image(systemName: type.icon)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
            }
            
            Text(message)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
            
            Spacer(minLength: 10)
            
            // Close button
            Button {
                withAnimation {
                    isShowing = false
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(customBackgroundColor ?? type.backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// Extension to View for easier toast presentation
extension View {
    func toast(
        message: String,
        type: ToastType = .info,
        position: ToastPosition = .bottom,
        showIcon: Bool = true,
        customBackgroundColor: Color? = nil,
        isShowing: Binding<Bool>
    ) -> some View {
        ZStack {
            self
            Toast(
                message: message,
                type: type,
                position: position,
                showIcon: showIcon,
                customBackgroundColor: customBackgroundColor,
                isShowing: isShowing
            )
        }
    }
}
