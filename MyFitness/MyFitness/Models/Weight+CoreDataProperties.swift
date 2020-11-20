//
//  Weight+CoreDataProperties.swift
//  
//
//  Created by John Kouris on 11/19/20.
//
//

import Foundation
import CoreData


extension Weight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weight> {
        return NSFetchRequest<Weight>(entityName: "Weight")
    }

    @NSManaged public var date: Date?
    @NSManaged public var value: Double

}
