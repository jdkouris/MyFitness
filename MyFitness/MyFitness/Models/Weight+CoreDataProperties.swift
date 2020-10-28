//
//  Weight+CoreDataProperties.swift
//  
//
//  Created by John Kouris on 10/27/20.
//
//

import Foundation
import CoreData


extension Weight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weight> {
        return NSFetchRequest<Weight>(entityName: "Weight")
    }

    @NSManaged public var weight: Double
    @NSManaged public var date: Date?

}
