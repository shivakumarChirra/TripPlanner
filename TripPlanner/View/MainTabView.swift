//
//  MainTabView.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 30/06/1947 Saka.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            TripsView()
                .tabItem { Label("Trips", systemImage: "airplane") }
            
            BudgetsView()
                .tabItem { Label("Budget", systemImage: "chart.pie") }
            
            MeView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}

#Preview {
    MainTabView()
}
