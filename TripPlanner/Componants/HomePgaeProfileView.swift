//
//  HomePgaeProfileView.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 30/06/1947 Saka.
//
import SwiftUI
struct HomeProfileAndHotPlacesView: View {
    var profileImage: UIImage?
    var username: String
    @Binding var searchText: String
    
    let imageItems: [HomeTopTripsImagesModel] = [
        HomeTopTripsImagesModel(imageName: "Image 11", title: "Mount Fuji", description: "A breathtaking view of Mount Fuji in Japan.", tripCost: 150),
        HomeTopTripsImagesModel(imageName: "Image 12", title: "Santorini", description: "Famous white-washed buildings with blue domes.", tripCost: 180),
        HomeTopTripsImagesModel(imageName: "Image 13", title: "Grand Canyon", description: "Experience the vastness of the Grand Canyon.", tripCost: 200),
        HomeTopTripsImagesModel(imageName: "Image 14", title: "Machu Picchu", description: "Explore the ancient Incan ruins in Peru.", tripCost: 220)
    ]
    
    @State private var backgroundIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.7))
                        )
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
            
            HStack {
                Spacer()
                ExpandableGlassSearchBar(searchText: $searchText)
               
            }
            .padding(.horizontal)
            
            AutoScrollingImageCarousel(items: imageItems)
                .frame(height: 220)
                .cornerRadius(20)
                .shadow(radius: 4)
        }
        .padding(.vertical)
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .padding(.horizontal)
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                backgroundIndex = (backgroundIndex + 1) % imageItems.count
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}

#Preview {
    HomeProfileAndHotPlacesView(profileImage: nil, username: "Shiv", searchText: .constant(""))
        .preferredColorScheme(.dark)
}
