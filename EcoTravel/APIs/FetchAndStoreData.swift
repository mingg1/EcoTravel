//
//  FetchAndStoreData.swift
//  EcoTravel
//
//  Created by iosdev on 27.4.2021.
//

import Foundation
import MOPRIMTmdSdk

class FetchAndStoreData {
    let managedObjectContext = AppDelegate.viewContext
    
    func fetchUsersTrips() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let startTime = formatter.date(from: "2021/01/01 00:00")
        let startTimeMilliseconds = Int64((startTime!.timeIntervalSince1970 * 1000.0).rounded())
        let endTime = Date()
        let endTimeMilliseconds = Int64((endTime.timeIntervalSince1970 * 1000.0).rounded())
        
        TMDCloudApi.fetchData(withStart: startTimeMilliseconds, withEnd: endTimeMilliseconds).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
                if let error = task.error {
                    NSLog("fetchData Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchData result: %@", data)
                    
                    var usersTrips = [Trip]()
                    
                    for trip in data {
                        let trip = trip as! TMDActivity
                        print("DATA: activityId: \(trip.activityId), timestampDownload: \(trip.timestampDownload), timestampStart: \(trip.timestampStart), timestampEnd: \(trip.timestampEnd), timestampUpdate: \(trip.timestampUpdate), correctedActivity: \(trip.correctedActivity), originalActivity: \(trip.originalActivity), co2: \(trip.co2), distance: \(trip.distance), speed: \(trip.speed), polyline: \(trip.polyline), origin: \(trip.origin), destination: \(trip.destination), metadata: \(trip.metadata), verifiedByUser: \(trip.verifiedByUser), syncedWithCloud: \(trip.syncedWithCloud)")
                        
                        let tripClass = Trip(activityId: Int(trip.activityId), timestampStart: Int(trip.timestampStart), timestampEnd: Int(trip.timestampEnd), correctedActivity: trip.correctedActivity, originalActivity: trip.originalActivity, co2: trip.co2, distance: trip.distance, speed: trip.speed, polyline: trip.polyline, origin: trip.origin, destination: trip.destination, metadata: trip.metadata)
                        
                        usersTrips.append(tripClass)
                    }
                    self.storeTripsToCoreData(usersTrips)
                }
            }
        }
    }
    
    func storeTripsToCoreData(_ usersTrips: [Trip]) {
        managedObjectContext.perform {
            for trip in usersTrips {
                let tripCoreData = try? TripCoreData.getOrCreateTripWith(activityId: trip.activityId, context: self.managedObjectContext)
                
                tripCoreData?.activityId = Int64(trip.activityId)
                tripCoreData?.timestampStart = Int64(trip.timestampStart)
                tripCoreData?.timestampEnd = Int64(trip.timestampEnd)
                tripCoreData?.correctedActivity = trip.correctedActivity
                tripCoreData?.originalActivity = trip.originalActivity
                tripCoreData?.co2 = trip.co2
                tripCoreData?.distance = trip.distance
                tripCoreData?.speed = trip.speed
                tripCoreData?.polyline = trip.polyline
                tripCoreData?.origin = trip.origin
                tripCoreData?.destination = trip.destination
                tripCoreData?.metadata = trip.metadata
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func fetchStatistics() {
        TMDCloudApi.fetchStats(forLast: 365).continueOnSuccessWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
                if let error = task.error {
                    NSLog("fetchStats Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchStats result: %@", data)
                    
                    var statistics = [Statistic]()
                    
                    for statistic in data.allStats() {
                        print("STATS: activity: \(statistic.activity), userCo2: \(statistic.userCo2), userDistance: \(statistic.userDistance), userDuration: \(statistic.userDuration), userLegs: \(statistic.userLegs), communityCo2: \(statistic.communityCo2), communityDistance: \(statistic.communityDistance), communityDuration: \(statistic.communityDuration), communityLegs: \(statistic.communityLegs), communitySize: \(statistic.communitySize), dateString: \(statistic.dateString)")
                        
                        let statisticClass = Statistic(activity: statistic.activity, userCo2: statistic.userCo2, userDistance: statistic.userDistance, userDuration: statistic.userDuration, userLegs: Int(statistic.userLegs), dateString: statistic.dateString)
                        
                        statistics.append(statisticClass)
                    }
                    self.storeStatisticsToCoreData(statistics)
                }
            }
        }
    }
    
    func storeStatisticsToCoreData(_ statistics: [Statistic]) {
        managedObjectContext.perform {
            for statistic in statistics {
                let statisticCoreData = try? StatisticCoreData.getOrCreateStatisticWith(activity: statistic.activity, dateString: statistic.dateString, context: self.managedObjectContext)
                
                statisticCoreData?.activity = statistic.activity
                statisticCoreData?.userCo2 = statistic.userCo2
                statisticCoreData?.userDistance = statistic.userDistance
                statisticCoreData?.userDuration = statistic.userDuration
                statisticCoreData?.userLegs = Int64(statistic.userLegs)
                statisticCoreData?.dateString = statistic.dateString
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
}
