//
//  Exercise+CoreDataProperties.swift
//  
//
//  Created by John Kouris on 10/27/20.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var reps: Int64
    @NSManaged public var weight: Double
    @NSManaged public var workout: Workout?

}
