//
//  LoginView.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//
import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with glossy gradient
                LinearGradient(colors: [.blue.opacity(0.7), .purple.opacity(0.6), .black.opacity(0.4)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Trip Planner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(colors: [.white, .blue],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username").formLabel()
                        
                        TextField("Enter username", text: $username)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(.white.opacity(0.1)))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.2)))
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password").formLabel()
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Enter password", text: $password)
                                    .foregroundColor(.white)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            } else {
                                SecureField("Enter password", text: $password)
                                    .foregroundColor(.white)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            
                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.white.opacity(0.1)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.2)))
                    }
                    
                    Button(action: loginUser) {
                        Text("Login")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.blue, .purple],
                                                       startPoint: .leading,
                                                       endPoint: .trailing))
                            .cornerRadius(12)
                            .shadow(radius: 6)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func loginUser() {
        if username.isEmpty || password.isEmpty {
            alertMessage = "Please fill all fields."
            showAlert = true
            return
        }
        
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@ AND password == %@", username, password)
        request.fetchLimit = 1
        
        do {
            let result = try viewContext.fetch(request)
            if let _ = result.first {
                isLoggedIn = true
            } else {
                alertMessage = "Invalid username or password"
                showAlert = true
            }
        } catch {
            alertMessage = "Login failed: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

#Preview {
    LoginView()
}
