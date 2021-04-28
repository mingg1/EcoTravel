//
//  Trip.swift
//  EcoTravel
//
//  Created by iosdev on 16.4.2021.
//

import Foundation

class Trip {
    
    let activityId: Int
    let timestampStart: Int
    let timestampEnd: Int
    let correctedActivity: String
    let originalActivity: String
    let co2: Double
    let distance: Double
    let speed: Double
    let polyline: String
    let origin: String
    let destination: String
    let metadata: String
    
    init(activityId: Int, timestampStart: Int, timestampEnd: Int, correctedActivity: String, originalActivity: String, co2: Double, distance: Double, speed: Double, polyline: String, origin: String, destination: String, metadata: String) {
        
        self.activityId = activityId
        self.timestampStart = timestampStart
        self.timestampEnd = timestampEnd
        self.correctedActivity = correctedActivity
        self.originalActivity = originalActivity
        self.co2 = co2
        self.distance = distance
        self.speed = speed
        self.polyline = polyline
        self.origin = origin
        self.destination = destination
        self.metadata = metadata
    }
}
