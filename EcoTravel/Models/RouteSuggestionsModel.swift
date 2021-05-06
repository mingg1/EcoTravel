/**
 * Structs for parsing the graphQL query
 * Author Minji Choi
 * since 2021-04-24
 */

import Foundation

/// Struct for parsing the graphQL query
struct Plan: Codable {
    var itineraries: [Itineraries]
}

/// Struct for a route option, showing duration time and legs
struct Itineraries: Codable {
    var duration: String
    var legs: [Legs]
}

/// Struct for parts of the itinerary
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

/// Struct for coordinate, name, and stop data
struct Place: Codable {
    var lat: Float
    var lon: Float
    var name: String
    var stop: Stop?
}

/// Struct for name and code of the stop
struct Stop: Codable {
    var code: String?
    var name: String
}

/// Struct for the transportation's line number and destination place name
struct Trips: Codable {
    var tripHeadsign: String
    var routeShortName: String
}

/// Struct for the polyline of the route
struct LegGeometry: Codable {
    var length: Int
    var points: String
}
