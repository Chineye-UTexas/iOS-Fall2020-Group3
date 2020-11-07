//
//  User+CoreDataProperties.swift
//  Made-App
//
//  Created by Megan Teo on 11/4/20.
//
//
import Foundation
import CoreData


extension User {

    @nonobjc public class func userFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var bio: String?
    @NSManaged public var name: String?
    @NSManaged public var notifications: Bool
    @NSManaged public var screenName: String?
    @NSManaged public var password: String?

}
