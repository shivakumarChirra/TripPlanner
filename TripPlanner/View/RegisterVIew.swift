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
    @StateObject private var viewModel: RegisterViewModel

    
    
    init(viewModel: RegisterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.black.opacity(0.9), .purple.opacity(0.5), .blue.opacity(0.4)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    // Header
                    VStack(spacing: 6) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Start planning your dream trips")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 40)
                    
                    // Form
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Name").formLabel()
                            inputField(icon: "person.fill",
                                       placeholder: "Username",
                                       text: $viewModel.username)
                        }
                        VStack(alignment: .leading) {
                            Text("E-Mail").formLabel()
                            inputField(icon: "envelope.fill",
                                       placeholder: "Email",
                                       text: $viewModel.email)
                                .keyboardType(.emailAddress)
                        }
                        VStack(alignment: .leading) {
                            Text("Password").formLabel()
                            HStack {
                                if viewModel.isPasswordVisible {
                                    TextField("Password", text: $viewModel.password)
                                        .foregroundColor(.white)
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                } else {
                                    SecureField("Password", text: $viewModel.password)
                                        .foregroundColor(.white)
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                }
                                Button { viewModel.isPasswordVisible.toggle() } label: {
                                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.08)))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.15)))
                        }
                        
                        // Register Button
                        Button(action: viewModel.registerUser) {
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
                    
                    // Navigation after registration
                    NavigationLink(destination: HomeView(),
                                   isActive: $viewModel.isRegistered) { EmptyView() }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Register"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
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
    RegisterView(viewModel: RegisterViewModel())
}

