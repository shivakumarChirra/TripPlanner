//
//  RegisterViewModel.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 19/09/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import CoreData
@MainActor
class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var isRegistered = false
    @Published var showAlert = false
    @Published var alertMessage = ""

    private let authService = FirebaseAuthService()
    private var context: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext? = nil) {
        self.context = context
    }
    
    func registerUser() {
        // 🔹 Validations
        guard username.count >= 3 else {
            alertMessage = "Username must be at least 3 characters."
            showAlert = true
            return
        }
        
        guard email.contains("@"), email.contains(".") else {
            alertMessage = "Please enter a valid email."
            showAlert = true
            return
        }
        
        guard password.count >= 4, password.count <= 10 else {
            alertMessage = "Password must be 4–10 characters long."
            showAlert = true
            return
        }
        
        if isConnectedToInternet() {
            // 🔹 Online: Register via Firebase
            authService.registerUser(email: email, password: password, username: username) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.saveUserToCoreData(synced: true) // Mark as synced
                        self?.isRegistered = true
                    case .failure(let error):
                        self?.alertMessage = error.localizedDescription
                        self?.showAlert = true
                    }
                }
            }
        } else {
            // 🔹 Offline: Save locally
            saveUserToCoreData(synced: false) // Mark as not yet synced
            isRegistered = true
        }
    }
    
    private func saveUserToCoreData(synced: Bool) {
        guard let context else { return }
        let user = UserEntity(context: context)
        user.username = username
        user.email = email
        user.password = password
        user.createdAt = Date()
        user.isSynced = synced   
        try? context.save()
    }
    
    private func isConnectedToInternet() -> Bool {
        // Replace this with real connectivity check
        return true
    }
    
    // 🔹 Sync unsynced users to Firebase
    func syncOfflineUsers() {
        guard let context else { return }
        
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isSynced == %@", NSNumber(value: false))
        
        if let unsyncedUsers = try? context.fetch(request) {
            for user in unsyncedUsers {
                authService.registerUser(email: user.email ?? "",
                                         password: user.password ?? "",
                                         username: user.username ?? "") { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            user.isSynced = true
                            try? context.save()
                        case .failure(let error):
                            self?.alertMessage = "Sync failed: \(error.localizedDescription)"
                            self?.showAlert = true
                        }
                    }
                }
            }
        }
    }
}
