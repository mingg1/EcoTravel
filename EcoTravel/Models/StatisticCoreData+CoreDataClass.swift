//
//  StatisticCoreData+CoreDataClass.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 28.4.2021.
//
//

import Foundation
import CoreData


// The Core Data class for statistics
public class StatisticCoreData: NSManagedObject {
    
    // Function for ensuring item uniqueness in the database
    class func getOrCreateStatisticWith (activity: String, dateString: String, context: NSManagedObjectContext) throws -> StatisticCoreData? {
        // Core Data fetch request is made with the activity and dateString properties as predicates
        let request: NSFetchRequest<StatisticCoreData> = StatisticCoreData.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "activity == %@", activity),
            NSPredicate(format: "dateString == %@", dateString)
        ])
        // If there is a matching item, it will be returned. Otherwise a new Core Data object is created and returned
        do {
            let matchingStatistics = try context.fetch(request)
            if matchingStatistics.count == 1 {
                return matchingStatistics[0]
            } else if (matchingStatistics.count == 0) {
                let newStatistic = StatisticCoreData(context: context)
                return newStatistic
            } else {
                print("Database inconsistent, found equal Statistics")
                return matchingStatistics[0]
            }
        } catch {
            throw error
        }
    }
}
