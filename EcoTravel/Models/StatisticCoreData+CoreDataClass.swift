//
//  StatisticCoreData+CoreDataClass.swift
//  EcoTravel
//
//  Created by iosdev on 28.4.2021.
//
//

import Foundation
import CoreData


public class StatisticCoreData: NSManagedObject {
    
    class func getOrCreateStatisticWith (activity: String, dateString: String, context: NSManagedObjectContext) throws -> StatisticCoreData? {
        let request: NSFetchRequest<StatisticCoreData> = StatisticCoreData.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "activity == %@", activity),
            NSPredicate(format: "dateString == %@", dateString)
        ])
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
