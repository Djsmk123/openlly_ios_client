//
//  EmailVerificationViewModel.swift
//  openlly
//
//  Created by Mobin on 31/12/24.
//


import SwiftUI
class EmailVerificationViewModel: ObservableObject {
    @Published var email = ""
    @Published var isMagicLinkSent = false
    @Published var countdown = 5
    @Published var canResend = false
    @Published var isLoading = false
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var toastStyle: ToastType = .success
    var toastDuration: Double = 2
    private let authRepo = AuthRepoImpl(networkService: APIClient())
    
    private var timer: Timer?
    
    func sendMagicLink(resent: Bool) {
        isLoading = true
        guard !email.isEmpty else {
            showToast(message: "Please enter a valid email address", type: .error, duration: toastDuration)
            isLoading = false
            return
        }
        authRepo.sendEmailVerification(email: email) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.isMagicLinkSent = true
                    self.startCountdown()
                    self.showToast(message: resent ? "Email verification link has been resent to your email." :
                        "Email verification link has been sent to your email.", type: .success, duration: self.toastDuration)
                case .failure(_):
                    self.showToast(message: resent ? "Email verification sending failed, please try again" :
                        "Email verification sending failed, please try again", type: .error, duration: self.toastDuration)
                }
            }
        }
    }
    
    func resendMagicLink() {
        sendMagicLink(resent: true)
    }
    func showToast(message:String, type: ToastType, duration: Double){
        self.showToast=true
        self.toastMessage=message
        self.toastStyle=type
        //hide toast after
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.showToast = false
        }
    }
    
    func startCountdown() {
        countdown = 5
        canResend = false
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                self.canResend = true
                timer.invalidate()
            }
        }
    }
    
    func resetState() {
        isMagicLinkSent = false
        canResend = false
        timer?.invalidate()
    }
    
    deinit {
        timer?.invalidate()
    }
}
