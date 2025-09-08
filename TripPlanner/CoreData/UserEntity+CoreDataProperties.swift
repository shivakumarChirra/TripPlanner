//
//  UserEntity+CoreDataProperties.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var profileImage: Data?

}

extension UserEntity : Identifiable {

}
extension UserEntity {
    static func fetchUser(context: NSManagedObjectContext) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserEntity.createdAt, ascending: false)]
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("⚠️ Failed to fetch user: \(error.localizedDescription)")
            return nil
        }
    }
}
