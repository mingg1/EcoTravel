//
//  ConversionTests.swift
//  EcoTravelTests
//
//  Created by Tuomas Bergholm on 15.4.2021.
//

import XCTest
@testable import EcoTravel
import CoreData

// Test class for trip property conversion functions
class EcoTravelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Test for converting trip activity name of a trip whose activity has not been corrected
    func testActivityNameConversionCarOriginal() throws {
        let managedObjectContext = AppDelegate.viewContext
        
        let tripRequest: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        tripRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "originalActivity == %@", "motorized/road/car"),
            NSPredicate(format: "correctedActivity == %@", "")
        ])
        let trips = try? managedObjectContext.fetch(tripRequest)
        
        guard let tripsArray = trips else {
            fatalError("Trips array is nil")
        }
        
        if (!tripsArray.isEmpty) {
            let randomIndex = Int.random(in: 0..<tripsArray.count)
            let exampleTrip = tripsArray[randomIndex]
            
            let tripPropertyConverter = TripPropertyConverter()
            let convertedName = tripPropertyConverter.convertFullActivityName(trip: exampleTrip)
            
            XCTAssert(convertedName == "Car", "Car original activity name conversion failed")
        }
    }
    
    // Test for converting trip activity name of a trip whose activity has been corrected
    func testActivityNameConversionCarCorrected() throws {
        let managedObjectContext = AppDelegate.viewContext
        
        let tripRequest: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        tripRequest.predicate = NSPredicate(format: "correctedActivity == %@", "motorized/road/car")
        let trips = try? managedObjectContext.fetch(tripRequest)
        
        guard let tripsArray = trips else {
            fatalError("Trips array is nil")
        }
        
        if (!tripsArray.isEmpty) {
            let randomIndex = Int.random(in: 0..<tripsArray.count)
            let exampleTrip = tripsArray[randomIndex]
            
            let tripPropertyConverter = TripPropertyConverter()
            let convertedName = tripPropertyConverter.convertFullActivityName(trip: exampleTrip)
            
            XCTAssert(convertedName == "Car", "Car corrected activity name conversion failed")
        }
    }
    
    // Test for converting trip activity name of a trip whose activity has not been corrected
    func testActivityNameConversionBicycleOriginal() throws {
        let managedObjectContext = AppDelegate.viewContext
        
        let tripRequest: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        tripRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "originalActivity == %@", "non-motorized/bicycle"),
            NSPredicate(format: "correctedActivity == %@", "")
        ])
        let trips = try? managedObjectContext.fetch(tripRequest)
        
        guard let tripsArray = trips else {
            fatalError("Trips array is nil")
        }
        
        if (!tripsArray.isEmpty) {
            let randomIndex = Int.random(in: 0..<tripsArray.count)
            let exampleTrip = tripsArray[randomIndex]
            
            let tripPropertyConverter = TripPropertyConverter()
            let convertedName = tripPropertyConverter.convertFullActivityName(trip: exampleTrip)
            
            XCTAssert(convertedName == "Bicycle", "Bicycle original activity name conversion failed")
        }
    }
    
    // Test for converting trip activity name of a trip whose activity has been corrected
    func testActivityNameConversionBicycleCorrected() throws {
        let managedObjectContext = AppDelegate.viewContext
        
        let tripRequest: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        tripRequest.predicate = NSPredicate(format: "correctedActivity == %@", "non-motorized/bicycle")
        let trips = try? managedObjectContext.fetch(tripRequest)
        
        guard let tripsArray = trips else {
            fatalError("Trips array is nil")
        }
        
        if (!tripsArray.isEmpty) {
            let randomIndex = Int.random(in: 0..<tripsArray.count)
            let exampleTrip = tripsArray[randomIndex]
            
            let tripPropertyConverter = TripPropertyConverter()
            let convertedName = tripPropertyConverter.convertFullActivityName(trip: exampleTrip)
            
            XCTAssert(convertedName == "Bicycle", "Bicycle corrected activity name conversion failed")
        }
    }
    
    // Test for converting a timestamp in milliseconds to a date string
    func testTimestampToDateStringConversion1() throws {
        let dateString = "05.05.2021 12:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let date = dateFormatter.date(from: dateString)
        let dateMilliseconds = Int((date!.timeIntervalSince1970 * 1000.0).rounded())
        
        let tripPropertyConverter = TripPropertyConverter()
        let dateConverted = tripPropertyConverter.convertTimestampToDateString(timestamp: dateMilliseconds)
        
        XCTAssert(dateConverted == dateString, "Timestamp to date string conversion failed")
    }
    
    // Test for converting a timestamp in milliseconds to a date string
    func testTimestampToDateStringConversion2() throws {
        let dateString = "28.04.2021 19:37"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let date = dateFormatter.date(from: dateString)
        let dateMilliseconds = Int((date!.timeIntervalSince1970 * 1000.0).rounded())
        
        let tripPropertyConverter = TripPropertyConverter()
        let dateConverted = tripPropertyConverter.convertTimestampToDateString(timestamp: dateMilliseconds)
        
        XCTAssert(dateConverted == dateString, "Timestamp to date string conversion failed")
    }
    
    // Test for getting an eco rating for an activity
    func testGetEcoRatingCar() {
        let activityName = "Car"
        let tripPropertyConverter = TripPropertyConverter()
        let ecoRating = tripPropertyConverter.getEcoRatingForTripActivity(activityName: activityName)
        
        XCTAssert(ecoRating == 2, "Eco rating for activity car was incorrect")
    }
    
    // Test for getting an eco rating for an activity
    func testGetEcoRatingElectricCar() {
        let activityName = "Electric car"
        let tripPropertyConverter = TripPropertyConverter()
        let ecoRating = tripPropertyConverter.getEcoRatingForTripActivity(activityName: activityName)
        
        XCTAssert(ecoRating == 4, "Eco rating for activity electric car was incorrect")
    }
}
