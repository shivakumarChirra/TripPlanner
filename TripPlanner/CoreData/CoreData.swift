//
//  CoreData.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//

import Foundation
import CoreData
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        let user = UserEntity(context: viewContext)
        user.username = "Traveler"
        user.profileImage = nil

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Core Data error \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed: \(error.localizedDescription)")
            }
        }
    }
}
