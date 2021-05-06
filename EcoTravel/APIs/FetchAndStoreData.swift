//
//  FetchAndStoreData.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 27.4.2021.
//

import Foundation
import MOPRIMTmdSdk

/// Class that includes functions related to fetching data from the Moprim API and storing it in Core Data
class FetchAndStoreData {
    let managedObjectContext = AppDelegate.viewContext
    
    // Function for fetching the user's trips from the API
    func fetchUsersTrips() {
        // Timestamps in milliseconds are created for the timeframe of the trips to be fetched
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let startTime = formatter.date(from: "01.01.2021 00:00")
        let startTimeMilliseconds = Int64((startTime!.timeIntervalSince1970 * 1000.0).rounded())
        let endTime = Date()
        let endTimeMilliseconds = Int64((endTime.timeIntervalSince1970 * 1000.0).rounded())
        
        // The trips are fetched from the API
        TMDCloudApi.fetchData(withStart: startTimeMilliseconds, withEnd: endTimeMilliseconds).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                if let error = task.error {
                    NSLog("fetchData Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchData result: %@", data)
                    
                    var usersTrips = [Trip]()
                    
                    // All the fetched trips are printed and an instance of the Trip class is created of each of them and added to an array
                    for trip in data {
                        let trip = trip as! TMDActivity
                        print("TRIP: activityId: \(trip.activityId), timestampDownload: \(trip.timestampDownload), timestampStart: \(trip.timestampStart), timestampEnd: \(trip.timestampEnd), timestampUpdate: \(trip.timestampUpdate), correctedActivity: \(trip.correctedActivity), originalActivity: \(trip.originalActivity), co2: \(trip.co2), distance: \(trip.distance), speed: \(trip.speed), polyline: \(trip.polyline), origin: \(trip.origin), destination: \(trip.destination), metadata: \(trip.metadata), verifiedByUser: \(trip.verifiedByUser), syncedWithCloud: \(trip.syncedWithCloud)")
                        
                        let tripClass = Trip(activityId: Int(trip.activityId), timestampStart: Int(trip.timestampStart), timestampEnd: Int(trip.timestampEnd), correctedActivity: trip.correctedActivity, originalActivity: trip.originalActivity, co2: trip.co2, distance: trip.distance, speed: trip.speed, polyline: trip.polyline, origin: trip.origin, destination: trip.destination, metadata: trip.metadata)
                        
                        usersTrips.append(tripClass)
                    }
                    // The trips in the array are stored to Core Data
                    self.storeTripsToCoreData(usersTrips)
                }
            }
        }
    }
    
    // Function for storing Trip objects to Core Data
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
    
    // Function for fetching the statistics from the API
    func fetchStatistics() {
        // The statistics for the last year are fetched from the API
        TMDCloudApi.fetchStats(forLast: 365).continueOnSuccessWith { (task) -> Any? in
            DispatchQueue.main.async {
                if let error = task.error {
                    NSLog("fetchStats Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchStats result: %@", data)
                    
                    var statistics = [Statistic]()
                    
                    // All the fetched statistics are printed and an instance of the Statistic class is created of each of them and added to an array
                    for statistic in data.allStats() {
                        print("STATISTIC: activity: \(statistic.activity), userCo2: \(statistic.userCo2), userDistance: \(statistic.userDistance), userDuration: \(statistic.userDuration), userLegs: \(statistic.userLegs), communityCo2: \(statistic.communityCo2), communityDistance: \(statistic.communityDistance), communityDuration: \(statistic.communityDuration), communityLegs: \(statistic.communityLegs), communitySize: \(statistic.communitySize), dateString: \(statistic.dateString)")
                        
                        let statisticClass = Statistic(activity: statistic.activity, userCo2: statistic.userCo2, userDistance: statistic.userDistance, userDuration: statistic.userDuration, userLegs: Int(statistic.userLegs), dateString: statistic.dateString)
                        
                        statistics.append(statisticClass)
                    }
                    // The statistics in the array are stored to Core Data
                    self.storeStatisticsToCoreData(statistics)
                }
            }
        }
    }
    
    // Function for storing Statistic objects to Core Data
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
