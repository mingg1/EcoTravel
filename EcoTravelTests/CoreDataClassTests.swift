//
//  CoreDataClassTests.swift
//  EcoTravelTests
//
//  Created by Tuomas Bergholm on 5.5.2021.
//

import XCTest
@testable import EcoTravel
import CoreData

// Test class for Core Data Classes
class CoreDataClassTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Test for ensuring Statistic item uniqueness in Core Data when creating a new object which is not yet in Core Data
    func testStatisticCoreDataClassGetCreateObject1() {
        let managedObjectContext = AppDelegate.viewContext
        
        let statistic = try? StatisticCoreData.getOrCreateStatisticWith(activity: "motorized/road/car", dateString: "2021-01-01", context: managedObjectContext)
        statistic?.activity = "motorized/road/car"
        statistic?.dateString = "2021-01-01"
        
        let statisticRequest: NSFetchRequest<StatisticCoreData> = StatisticCoreData.fetchRequest()
        statisticRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "activity == %@", "motorized/road/car"),
            NSPredicate(format: "dateString == %@", "2021-01-01")
        ])
        let statistics = try? managedObjectContext.fetch(statisticRequest)
        
        let statisticsCount = statistics?.count
        
        XCTAssert(statisticsCount == 1, "Statistic Core Data object creation failed")
    }
    
    // Test for ensuring Statistic item uniqueness in Core Data when creating an object which is already in Core Data
    func testStatisticCoreDataClassGetCreateObject2() {
        let managedObjectContext = AppDelegate.viewContext
        
        let statistic1 = try? StatisticCoreData.getOrCreateStatisticWith(activity: "motorized/road/car", dateString: "2021-01-02", context: managedObjectContext)
        statistic1?.activity = "motorized/road/car"
        statistic1?.dateString = "2021-01-02"
        
        let statistic2 = try? StatisticCoreData.getOrCreateStatisticWith(activity: "motorized/road/car", dateString: "2021-01-02", context: managedObjectContext)
        statistic2?.activity = "motorized/road/car"
        statistic2?.dateString = "2021-01-02"
        
        let statisticRequest: NSFetchRequest<StatisticCoreData> = StatisticCoreData.fetchRequest()
        statisticRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "activity == %@", "motorized/road/car"),
            NSPredicate(format: "dateString == %@", "2021-01-02")
        ])
        let statistics = try? managedObjectContext.fetch(statisticRequest)
        
        let statisticsCount = statistics?.count
        
        XCTAssert(statisticsCount == 1, "Statistic Core Data object uniqueness failed")
    }
    
    // Test for ensuring Trip item uniqueness in Core Data when creating a new object which is not yet in Core Data
    func testTripCoreDataClassGetCreateObject1() {
        let managedObjectContext = AppDelegate.viewContext
        
        let trip = try? TripCoreData.getOrCreateTripWith(activityId: 1000000, context: managedObjectContext)
        trip?.activityId = 1000000
        
        let tripRequest: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        tripRequest.predicate = NSPredicate(format: "activityId == %d", 1000000)
        let trips = try? managedObjectContext.fetch(tripRequest)
        
        let tripsCount = trips?.count
        
        XCTAssert(tripsCount == 1, "Trip Core Data object creation failed")
    }
    
    // Test for ensuring Trip item uniqueness in Core Data when creating an object which is already in Core Data
    func testTripCoreDataClassGetCreateObject2() {
        let managedObjectContext = AppDelegate.viewContext
        
        let trip1 = try? TripCoreData.getOrCreateTripWith(activityId: 1000000, context: managedObjectContext)
        trip1?.activityId = 1000000
        
        let trip2 = try? TripCoreData.getOrCreateTripWith(activityId: 1000000, context: managedObjectContext)
        trip2?.activityId = 1000000
        
        let tripRequest: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        tripRequest.predicate = NSPredicate(format: "activityId == %d", 1000000)
        let trips = try? managedObjectContext.fetch(tripRequest)
        
        let tripsCount = trips?.count
        
        XCTAssert(tripsCount == 1, "Trip Core Data object uniqueness failed")
    }
}
