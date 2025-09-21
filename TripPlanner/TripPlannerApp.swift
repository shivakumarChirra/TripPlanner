//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.

import SwiftUI
import CoreData
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()  
        return true
    }
}

@main
struct TripPlannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct RootView: View {
    @State private var isLoggedIn: Bool = Auth.auth().currentUser != nil
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        Group {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView(viewModel: LoginViewModel(context: persistenceController.container.viewContext))
            }
        }
        .onAppear {
            // 🔹 Listen for login/logout changes
            Auth.auth().addStateDidChangeListener { _, user in
                withAnimation {
                    isLoggedIn = (user != nil)
                }
            }
        }
    }
}
