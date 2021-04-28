//
//  TripCoreData+CoreDataClass.swift
//  EcoTravel
//
//  Created by iosdev on 27.4.2021.
//
//

import Foundation
import CoreData


public class TripCoreData: NSManagedObject {

    class func getOrCreateTripWith (activityId: Int, context: NSManagedObjectContext) throws -> TripCoreData? {
        let request: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "activityId == %d", activityId)
        do {
            let matchingTrips = try context.fetch(request)
            if matchingTrips.count == 1 {
                return matchingTrips[0]
            } else if (matchingTrips.count == 0) {
                let newTrip = TripCoreData(context: context)
                return newTrip
            } else {
                print("Database inconsistent, found equal Trips")
                return matchingTrips[0]
            }
        } catch {
            throw error
        }
    }
}
