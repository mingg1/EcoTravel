// Struct for objets in itinerary plans
// Author: Minji Choi

import Foundation

struct Plan: Codable {
    var itineraries: [Itineraries]
}

struct Itineraries: Codable {
    var walkDistance: Float
    var duration: String
    var legs: [Legs]
}

struct Legs: Codable {
    var distance: Float
    var mode: String
    var startTime: String
    var endTime: String
    var from: Place
    var to: Place
    var trip: Trips?
    var legGeometry: LegGeometry
}

struct Place: Codable {
    var lat: Float
    var lon: Float
    var name: String
    var stop: Stop?
}

struct Stop: Codable {
    var code: String?
    var name: String
}

struct Trips: Codable {
    var tripHeadsign: String
    var routeShortName: String
}

struct LegGeometry: Codable {
    var length: Int
    var points: String
}
