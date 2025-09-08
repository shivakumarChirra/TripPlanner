//
//  ContentView.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//

import SwiftUI
import PhotosUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
 
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var username: String = "Traveler"
    
    var body: some View {
    

        ZStack {
            LinearGradient(colors: [.black.opacity(0.95), .blue.opacity(0.4), .purple.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    if let profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 60, height: 60)
                            .overlay(Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.7)))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Welcome back, \(username)!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("Ready to plan your next adventure?")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "bell.badge")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Text("Quick Actions")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                HStack {
                    QuickActionCard(icon: "wand.and.stars", title: "AI Trips", subtitle: "Smart plans")
                    QuickActionCard(icon: "airplane", title: "My Trips", subtitle: "Your journeys")
                }
                .padding(.horizontal)
                
                HStack {
                    QuickActionCard(icon: "dollarsign.circle", title: "Budget", subtitle: "Track expenses")
                    QuickActionCard(icon: "plus.circle", title: "Add Trip", subtitle: "Create new")
                }
                .padding(.horizontal)
                
                Spacer()
                
                TabView {
                    Text("Home").tabItem { Label("Home", systemImage: "house.fill") }
                    Text("Trips").tabItem { Label("Trips", systemImage: "airplane") }
                    Text("Budget").tabItem { Label("Budget", systemImage: "chart.pie") }
                    Text("Profile").tabItem { Label("Profile", systemImage: "person") }
                }
            }
        }
        .onAppear {
            if let user = UserEntity.fetchUser(context: viewContext) {
                username = user.name ?? "Traveler"
                if let imageData = user.profileImage {
                    profileImage = UIImage(data: imageData)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
