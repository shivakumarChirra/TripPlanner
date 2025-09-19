//
//  Authentication.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 19/09/25.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func registerUser(email: String, password: String, username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(.failure(NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing UID"])))
                return
            }
            
            let userData: [String: Any] = [
                "uid": uid,
                "username": username,
                "email": email,
                "createdAt": Timestamp(date: Date())
            ]
            
            self?.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    /// Login user with email + password
    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
