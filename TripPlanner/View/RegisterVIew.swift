//
//  RegisterVIew.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//

import SwiftUI
import CoreData

struct RegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isRegistered: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.black.opacity(0.9), .purple.opacity(0.5), .blue.opacity(0.4)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    VStack(spacing: 6) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Start planning your dream trips ")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Name").formLabel()
                            inputField(icon: "person.fill", placeholder: "Username", text: $username)
                        }
                        VStack(alignment: .leading) {
                            Text("E-Mail").formLabel()
                            inputField(icon: "envelope.fill", placeholder: "Email", text: $email)
                                .keyboardType(.emailAddress)
                        }
                        VStack(alignment: .leading) {
                            Text("Password").formLabel()
                            HStack {
                                if isPasswordVisible {
                                    TextField("Password", text: $password)
                                        .foregroundColor(.white)
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                } else {
                                    SecureField("Password", text: $password)
                                        .foregroundColor(.white)
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                }
                                Button { isPasswordVisible.toggle() } label: {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.08)))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.15)))
                        }
                        
                        Button(action: registerUser) {
                            Text("Register")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [.blue, .purple],
                                                           startPoint: .leading,
                                                           endPoint: .trailing))
                                .cornerRadius(15)
                                .shadow(radius: 6)
                        }
                        .padding(.top, 10)
                        
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white.opacity(0.7))
                            NavigationLink("Login", destination: LoginView())
                                .foregroundColor(.blue.opacity(0.9))
                        }
                        .font(.footnote)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                    
                    NavigationLink(destination: HomeView(), isActive: $isRegistered) { EmptyView() }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Register"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func registerUser() {
        if username.isEmpty || email.isEmpty || password.isEmpty {
            alertMessage = "All fields are required!"
            showAlert = true
            return
        }
        
        let newUser = UserEntity(context: viewContext)
        newUser.name = username
        newUser.email = email
        newUser.password = password
        newUser.createdAt = Date()
        
        do {
            try viewContext.save()
            isRegistered = true
        } catch {
            alertMessage = "Failed to save user: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

extension RegisterView {
    func inputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.white.opacity(0.7))
            TextField(placeholder, text: text)
                .foregroundColor(.white)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.15)))
    }
}


#Preview {
    RegisterView()
}
