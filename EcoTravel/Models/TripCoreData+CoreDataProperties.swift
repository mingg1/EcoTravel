//
//  TripCoreData+CoreDataProperties.swift
//  EcoTravel
//
//  Created by iosdev on 27.4.2021.
//
//

import Foundation
import CoreData


extension TripCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripCoreData> {
        return NSFetchRequest<TripCoreData>(entityName: "TripCoreData")
    }

    @NSManaged public var activityId: Int64
    @NSManaged public var timestampStart: Int64
    @NSManaged public var timestampEnd: Int64
    @NSManaged public var correctedActivity: String?
    @NSManaged public var originalActivity: String?
    @NSManaged public var co2: Double
    @NSManaged public var distance: Double
    @NSManaged public var speed: Double
    @NSManaged public var polyline: String?
    @NSManaged public var origin: String?
    @NSManaged public var destination: String?
    @NSManaged public var metadata: String?

}

extension TripCoreData : Identifiable {

}
