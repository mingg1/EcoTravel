//
//  TripCoreData+CoreDataClass.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 27.4.2021.
//
//

import Foundation
import CoreData


/// The Core Data class for trips
public class TripCoreData: NSManagedObject {

    // Function for ensuring item uniqueness in the database
    class func getOrCreateTripWith (activityId: Int, context: NSManagedObjectContext) throws -> TripCoreData? {
        // Core Data fetch request is made with the activityId as a predicate
        let request: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "activityId == %d", activityId)
        // If there is a matching item, it will be returned. Otherwise a new Core Data object is created and returned
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
