//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//

import SwiftUI
import CoreData
import FirebaseCore


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
            RegisterView(viewModel: RegisterViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
