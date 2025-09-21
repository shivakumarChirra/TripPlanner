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
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            // Main background gradient
            LinearGradient(colors: [.black.opacity(0.95), .blue.opacity(0.4), .purple.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Profile + Hot Places section
                    HomeProfileAndHotPlacesView(profileImage: profileImage,
                                                username: username,
                                                searchText: $searchText)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            QuickActionCard(icon: "wand.and.stars", title: "AI Trips", subtitle: "Smart plans")
                            QuickActionCard(icon: "airplane", title: "My Trips", subtitle: "Your journeys")
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            QuickActionCard(icon: "dollarsign.circle", title: "Budget", subtitle: "Track expenses")
                            QuickActionCard(icon: "plus.circle", title: "Add Trip", subtitle: "Create new")
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }.navigationBarBackButtonHidden()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadUserData()
        }
    }
    
    /// Fetch last registered/logged-in user from Core Data
    private func loadUserData() {
        // Attempt to fetch the last user saved in Core Data
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        request.fetchLimit = 1
        
        do {
            if let user = try viewContext.fetch(request).first {
                username = user.username ?? "Traveler"
                if let data = user.profileImage {
                    profileImage = UIImage(data: data)
                }
            }
        } catch {
            print("Failed to fetch user from Core Data:", error.localizedDescription)
        }
    }
}

// Preview
#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
