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
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(colors: [.indigo.opacity(0.8), .purple.opacity(0.6), .black.opacity(0.7)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 28) {
                    Spacer()
                    
                    // App title
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
                    
                    // Glassy card
                    if #available(iOS 16.0, *) {
                        VStack(spacing: 20) {
                            // Username
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Username").formLabel()
                                TextField("Enter username", text: $viewModel.username)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                            }
                            
                            // Password
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
                            
                            // Login button
                            Button(action: viewModel.loginUser) {
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
                            .disabled(viewModel.isLoading) // prevent double-taps
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal, 28)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: HomeView(),
                                   isActive: $viewModel.isLoggedIn) {
                        EmptyView()
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Login"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    LoginView()
}
