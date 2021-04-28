//
//  StatisticCoreData+CoreDataProperties.swift
//  EcoTravel
//
//  Created by iosdev on 28.4.2021.
//
//

import Foundation
import CoreData


extension StatisticCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatisticCoreData> {
        return NSFetchRequest<StatisticCoreData>(entityName: "StatisticCoreData")
    }

    @NSManaged public var activity: String?
    @NSManaged public var userCo2: Double
    @NSManaged public var userDistance: Double
    @NSManaged public var userDuration: Double
    @NSManaged public var userLegs: Int64
    @NSManaged public var dateString: String?

}

extension StatisticCoreData : Identifiable {

}
