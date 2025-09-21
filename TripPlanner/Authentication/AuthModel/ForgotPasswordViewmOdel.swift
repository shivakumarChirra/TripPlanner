//
//  ForgotPasswordViewmOdel.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 01/07/1947 Saka.
//

import Foundation
import FirebaseAuth

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var isLoading = false
    
    func sendResetLink() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email"
            showAlert = true
            return
        }
        
        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.alertMessage = error.localizedDescription
                } else {
                    self?.alertMessage = "A password reset link has been sent to  \(self?.email ?? "") check  your\(self?.email ?? "") inbox to reset your password. Also check your spam folder if you don't see it there. It may take a few minutes to appear in your spams."
                }
                self?.showAlert = true
            }
        }
    }
}
