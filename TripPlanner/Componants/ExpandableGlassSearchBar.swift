//
//  ExpandableGlassSearchBar.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 30/06/1947 Saka.
//

import SwiftUI


// MARK: - Image Detail
struct ImageDetailView: View {
    let item: HomeTopTripsImagesModel

    @State private var startLocation: String = ""
    @State private var destination: String = ""
    @State private var computedPrice: Double?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipped()

                Text(item.title)
                    .font(.title)
                    .bold()

                Text(item.description)
                    .font(.body)
                    .padding(.horizontal)

                Text("Base Trip Cost: \(String(format: "%.2f", item.tripCost))$")
                    .font(.headline)

                VStack(spacing: 12) {
                    TextField("Starting Location", text: $startLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("Destination", text: $destination)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                Button("Show Price") {
                    computedPrice = item.tripCost
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                if let price = computedPrice {
                    Text("Price: \(String(format: "%.2f", price))$")
                        .font(.title2)
                        .bold()
                }

                Spacer()
            }
            .navigationTitle(item.title)
        }
    }
}

// MARK: - Auto Carousel
struct AutoScrollingImageCarousel: View {
    let items: [HomeTopTripsImagesModel]
    @State private var scrollIndex = 0
    @State private var timer: Timer?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(items.indices, id: \.self) { i in
                        NavigationLink(destination: ImageDetailView(item: items[i])) {
                            ZStack(alignment: .bottomLeading) {
                                Image(items[i].imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 350, height: 200)
                                    .clipped()
                                    .cornerRadius(15)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(items[i].title)
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.white)

                                    Text(items[i].description)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                }
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                            }
                        }
                        .id(i)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        scrollIndex = (scrollIndex + 1) % items.count
                        proxy.scrollTo(scrollIndex, anchor: .center)
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
    }
}

struct HotPlaces: View {
    @State private var searchText = ""
    @State private var backgroundIndex = 0
    @State private var timer: Timer?

    let backgroundImages = ["Image 11", "Image 12", "Image 13"]
    let imageItems: [HomeTopTripsImagesModel] = [
        HomeTopTripsImagesModel(imageName: "Image 11", title: "Mount Fuji", description: "A breathtaking view of Mount Fuji in Japan.", tripCost: 150),
        HomeTopTripsImagesModel(imageName: "Image 12", title: "Santorini", description: "Famous white-washed buildings with blue domes.", tripCost: 180),
        HomeTopTripsImagesModel(imageName: "Image 13", title: "Grand Canyon", description: "Experience the vastness of the Grand Canyon.", tripCost: 200),
        HomeTopTripsImagesModel(imageName: "Image 14", title: "Machu Picchu", description: "Explore the ancient Incan ruins in Peru.", tripCost: 220)
    ]

    var body: some View {
       
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 10) {
                        Spacer().frame(height: 10)
                        NavigationLink(destination: NearPlacesView()) {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("Near You")
                            }
                            .foregroundColor(.white)
                            .adaptiveGlass(RoundedRectangle(cornerRadius: 15))
                        }

                        AutoScrollingImageCarousel(items: imageItems)

                        Spacer().frame(height: 100)
                    }
                }
            }
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                    backgroundIndex = (backgroundIndex + 1) % backgroundImages.count
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        
    }
}

// MARK: - Near Places
struct NearPlacesView: View {
    var body: some View {
        VStack {
            Text("Near Places")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .navigationTitle("Near Places")
    }
}

struct ExpandableGlassSearchBar: View {
    @Binding var searchText: String
    @State private var isExpanded: Bool = false
    @State private var rotationAngle: Double = 0

    var body: some View {
        HStack(spacing: 0) {
            if isExpanded {
                TextField("Search...", text: $searchText)
                    .padding(.horizontal, 10)
                    .frame(height: 45)
                    .foregroundColor(.white)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }

            Button(action: {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isExpanded.toggle()
                    rotationAngle += 360
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(10)
                    .rotationEffect(.degrees(rotationAngle))
            }
        }
        .padding(.horizontal, 10)
        .frame(width: isExpanded ? 250 : 40, height: 40)
        .adaptiveGlass(Capsule())
        .overlay(
            Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
        .padding(.horizontal)
    }
}

// MARK: - Adaptive Glass Extension
// MARK: - Adaptive Glass Extension
extension View {
    @ViewBuilder
    func adaptiveGlass<S: Shape>(_ shape: S) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect().clipShape(shape)
        } else {
            self.background(.ultraThinMaterial).clipShape(shape)
        }
    }
}

// MARK: - Previews
#Preview {
    HotPlaces()
}

#Preview {
    ExpandableGlassSearchBar(searchText: .constant(""))
}
