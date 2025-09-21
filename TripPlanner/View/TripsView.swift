//
//  TripsView.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 30/06/1947 Saka.
//

import SwiftUI


struct TripsView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.4), .purple.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Trips")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}


#Preview {
    MainTabView()
}
