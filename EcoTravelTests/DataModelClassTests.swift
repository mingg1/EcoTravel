//
//  DataModelClassTests.swift
//  EcoTravelTests
//
//  Created by Tuomas Bergholm on 5.5.2021.
//

import XCTest
@testable import EcoTravel

/// Test class for data model classes
class DataModelClassTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Test for creating a Statistic class object
    func testCreateStatisticClassObject() {
        let statistic = Statistic(activity: "walk", userCo2: 0.0, userDistance: 2000.0, userDuration: 1500, userLegs: 1, dateString: "2021-05-05")
        
        let activity = statistic.activity
        let userDistance = statistic.userDistance
        
        XCTAssert(activity == "walk" && userDistance == 2000.0, "Statistic object initialized with wrong values")
    }
    
    // Test for creating a Trip class object
    func testCreateTripClassObject() {
        let startTime = "05.05.2021 11:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let startTimeDate = dateFormatter.date(from: startTime)
        let startTimeMilliseconds = Int((startTimeDate!.timeIntervalSince1970 * 1000.0).rounded())
        let endTime = "05.05.2021 11:35"
        let endTimeDate = dateFormatter.date(from: endTime)
        let endTimeMilliseconds = Int((endTimeDate!.timeIntervalSince1970 * 1000.0).rounded())
        
        let trip = Trip(activityId: 23, timestampStart: startTimeMilliseconds, timestampEnd: endTimeMilliseconds, correctedActivity: "", originalActivity: "bicycle", co2: 0.0, distance: 6000.0, speed: 30.0, polyline: "abcd", origin: "a", destination: "b", metadata: "Good trip")
        
        let activityId = trip.activityId
        let originalActivity = trip.originalActivity
          
        XCTAssert(activityId == 23 && originalActivity == "bicycle", "Statistic object initialized with wrong values")
    }
}
