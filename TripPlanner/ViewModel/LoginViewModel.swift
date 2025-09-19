//
//  LoginViewModel.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 28/06/1947 Saka.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class LoginViewModel : ObservableObject {
    
    @Published  var username: String = ""
    @Published  var password: String = ""
    @Published  var isPasswordVisible: Bool = false
    @Published  var showAlert: Bool = false
    @Published  var alertMessage: String = ""
    @Published  var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false   

    
    private let db = Firestore.firestore()
     
     func loginUser() {
         // First, fetch email by username (since Firebase Auth uses email)
         db.collection("users")
             .whereField("username", isEqualTo: username)
             .getDocuments { [weak self] snapshot, error in
                 guard let self = self else { return }
                 
                 if let error = error {
                     self.alertMessage = "Error: \(error.localizedDescription)"
                     self.showAlert = true
                     return
                 }
                 
                 guard let document = snapshot?.documents.first,
                       let email = document["email"] as? String else {
                     self.alertMessage = "Username not found"
                     self.showAlert = true
                     return
                 }
                 
                 // Authenticate with Firebase using email + password
                 Auth.auth().signIn(withEmail: email, password: self.password) { result, error in
                     if let error = error {
                         self.alertMessage = error.localizedDescription
                         self.showAlert = true
                         return
                     }
                     
                     // Success
                     DispatchQueue.main.async {
                         self.isLoggedIn = true
                     }
                 }
             }
     }
}
