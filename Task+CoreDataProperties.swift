//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Muhammad Luqman on 10/30/20.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var priority: String?
    @NSManaged public var dateTime: Date?
    @NSManaged public var isComplete: Bool
    @NSManaged public var id: String?

}
