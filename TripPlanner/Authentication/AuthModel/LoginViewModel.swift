//
//  LoginViewModel.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 28/06/1947 Saka.
//
import Foundation
import FirebaseAuth
import CoreData

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var isPasswordVisible = false
    @Published var isLoggedIn = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var failedAttempts = 0
    @Published var isLoginDisabled = false
    @Published var showForgotButton = false

    private let authService = FirebaseAuthService()
    private var context: NSManagedObjectContext?

    init(context: NSManagedObjectContext? = nil) {
        self.context = context
    }

    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "All fields are required!"
            showAlert = true
            return
        }

        isLoading = true

        authService.loginUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.failedAttempts = 0
                    self?.isLoggedIn = true
                    self?.fetchUserFromCoreData()
                case .failure(let error):
                    self?.failedAttempts += 1
                    if self?.failedAttempts ?? 0 >= 5 {
                        self?.isLoginDisabled = true
                        self?.showForgotButton = true
                    }
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

    private func fetchUserFromCoreData() {
        guard let context else { return }
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "email == %@", email)
        if let user = try? context.fetch(request).first {
            username = user.username ?? "Traveler"
        } else {
            username = "Traveler"
        }
    }
}
