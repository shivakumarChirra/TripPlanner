//
//  LoginView.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//


import SwiftUI
import CoreData
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.indigo.opacity(0.8), .purple.opacity(0.6), .black.opacity(0.2)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 28) {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Trip Planner")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(.linearGradient(colors: [.white, .blue],
                                                             startPoint: .leading,
                                                             endPoint: .trailing))
                        
                        Text("Plan your adventures smarter")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.bottom, 40)
                    
                    if #available(iOS 16.0, *) {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Email").formLabel()
                                TextField("Enter email", text: $viewModel.email)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Password").formLabel()
                                HStack {
                                    if viewModel.isPasswordVisible {
                                        TextField("Enter password", text: $viewModel.password)
                                            .foregroundColor(.white)
                                    } else {
                                        SecureField("Enter password", text: $viewModel.password)
                                            .foregroundColor(.white)
                                    }
                                    Button {
                                        withAnimation(.easeInOut) {
                                            viewModel.isPasswordVisible.toggle()
                                        }
                                    } label: {
                                        Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                            }
                            
                            // Login Button
                            Button(action: {
                                viewModel.loginUser()
                            }) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                } else {
                                    Text("Login")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                            }
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                            .shadow(radius: 8)
                            .padding(.top, 6)
                            .disabled(viewModel.isLoading || viewModel.isLoginDisabled)
                            
                            // Show Forgot Password if login fails 5 times
                            if viewModel.showForgotButton {
                                NavigationLink("Forgot Password?", destination: ForgotPasswordView()
                                                .onDisappear {
                                                    // Reset login state after sending password reset
                                                    viewModel.isLoginDisabled = false
                                                    viewModel.failedAttempts = 0
                                                    viewModel.showForgotButton = false
                                                })
                                .foregroundColor(.red)
                                .padding(.top, 8)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal, 28)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: MainTabView(),
                                   isActive: $viewModel.isLoggedIn) { EmptyView() }
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white.opacity(0.7))
                        NavigationLink("Register", destination: RegisterView(viewModel: RegisterViewModel(context: viewContext)))
                            .foregroundColor(.blue.opacity(0.9))
                    }
                    .font(.footnote)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Login"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }.navigationBarBackButtonHidden()
    }
}


#Preview {
    LoginView(viewModel: LoginViewModel(context: PersistenceController.preview.container.viewContext))
}
