//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//

import SwiftUI
import CoreData

@main
struct TripPlannerApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            RegisterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
