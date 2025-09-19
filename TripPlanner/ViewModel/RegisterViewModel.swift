//
//  RegisterViewModel.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 19/09/25.
//

import Foundation
import CoreData
import SwiftUI

@MainActor

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isRegistered: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let authService = FirebaseAuthService()
    
    func registerUser() {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            alertMessage = "All fields are required!"
            showAlert = true
            return
        }
        
        authService.registerUser(email: email, password: password, username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isRegistered = true
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}
