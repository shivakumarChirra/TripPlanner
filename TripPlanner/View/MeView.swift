//
//  MeView.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 30/06/1947 Saka.
//

import SwiftUI
import FirebaseAuth

struct MeView: View {
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var profileImage: UIImage? = nil
    @State private var isEditing = false
    @State private var showImagePicker = false
@State var logOut = false
    let predefinedImageNames = (1...20).map { "Image \($0)" }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 10)

                    VStack(spacing: 16) {
                        profileImageView

                        if isEditing {
                            TextField("Name", text: $userName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)

                            TextField("Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                        } else {
                            Text(userName)
                                .font(.title)
                                .bold()
                                .foregroundStyle(.white)

                            Text(email)
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding(.top, 40)
                    .multilineTextAlignment(.center)
                    HStack{
                        Button("Logout") {
                            try? Auth.auth().signOut()
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                            logOut = true
                        }
                        .fullScreenCover(isPresented: $logOut) {
                            LoginView(viewModel: LoginViewModel(context: PersistenceController.shared.container.viewContext))
                        }
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Text(isEditing ? "Save" : "Edit")
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 350)
                .padding(.horizontal)

                
                HStack(spacing: 16) {
                    StatTile(title: "Trips", value: "12")
                    StatTile(title: "Countries", value: "5")
                    StatTile(title: "Upcoming", value: "3")
                }
                .padding(.horizontal)

                Spacer()
            }

            
            if showImagePicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showImagePicker = false
                    }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Choose Profile Image")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                            ForEach(predefinedImageNames, id: \.self) { imageName in
                                if let uiImage = UIImage(named: imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            profileImage = uiImage
                                            showImagePicker = false
                                        }
                                } else {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Button("Cancel") {
                        showImagePicker = false
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .frame(width: 250, height: 250)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
            }
        }
        .onAppear {
            fetchProfileData()
        }
    }

    var profileImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let image = profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 2))
                    .shadow(radius: 10)
            } else {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 50))
                            .foregroundStyle(.white.opacity(0.8))
                    )
            }

            if isEditing {
                Button(action: {
                    showImagePicker = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.blue))
                }
                .offset(x: 5, y: 5)
            }
        }
    }

    func fetchProfileData() {
        userName = "Shiva Kumar"
        email = "Shiva@gmail.com"
    }
}

struct StatTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .bold()
                .foregroundStyle(.white)

            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(width: 100, height: 100)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .white.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}



#Preview {
    MeView()
}
