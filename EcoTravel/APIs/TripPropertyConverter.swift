//
//  TripPropertyConverter.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 3.5.2021.
//

import Foundation

/// Class for converting different properties of trips to different formats
class TripPropertyConverter {
    
    // Function for converting the full activity name of trips to a more readable, shorter version
    func convertFullActivityName(trip: TripCoreData) -> String {
        // If the correctedActivity is not empty, i.e. the activity name has been corrected, it is used, otherwise the originalActivity is used
        var correctActivity: String
        if(trip.correctedActivity != "") {
            correctActivity = trip.correctedActivity ?? "No activity"
        } else {
            correctActivity = trip.originalActivity ?? "No activity"
        }
        
        // The activity name is set based on the original value and then returned
        var activityName: String
        switch correctActivity {
        case "unknown":
            activityName = "Unknown"
        case "stationary":
            activityName = "Stationary"
        case "non-motorized":
            activityName = "Non-motorized"
        case "non-motorized/bicycle":
            activityName = "Bicycle"
        case "non-motorized/pedestrian":
            activityName = "Pedestrian"
        case "non-motorized/pedestrian/walk":
            activityName = "Walk"
        case "non-motorized/pedestrian/run":
            activityName = "Run"
        case "motorized":
            activityName = "Motorized"
        case "motorized/road":
            activityName = "Motorized/road"
        case "motorized/road/car":
            activityName = "Car"
        case "motorized/road/bus":
            activityName = "Bus"
        case "motorized/rail":
            activityName = "Rail"
        case "motorized/rail/tram":
            activityName = "Tram"
        case "motorized/rail/train":
            activityName = "Train"
        case "motorized/rail/metro":
            activityName = "Metro"
        case "motorized/air/plane":
            activityName = "Plane"
        case "non-motorized/wheelchair":
            activityName = "Wheelchair"
        case "non-motorized/snow/cross-country-skiing":
            activityName = "Cross-country-skiing"
        case "motorized/road/kickscooter/electric":
            activityName = "Electric kickscooter"
        case "motorized/road/bicycle/electric":
            activityName = "Electric bicycle"
        case "motorized/road/car/electric":
            activityName = "Electric car"
        case "motorized/road/motorbike":
            activityName = "Motorbike"
        case "motorized/road/scooter":
            activityName = "Scooter"
        case "motorized/water/ferry":
            activityName = "Ferry"
        case "non-motorized/snow":
            activityName = "Snow"
        case "motorized/water":
            activityName = "Water"
        case "motorized/air":
            activityName = "Air"
        default:
            activityName = "No activity"
        }
        
        return activityName
    }
    
    // Function for converting timestamps in milliseconds to date strings
    func convertTimestampToDateString(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
    
    // Function for getting the rating for a specific trip activity type
    func getEcoRatingForTripActivity(activityName: String) -> Int {
        var rating: Int
        switch activityName {
        case "Plane", "Air":
            rating = 1
        case "Motorized", "Motorized/road", "Car", "Motorbike", "Water":
            rating = 2
        case "Bus", "Scooter", "Ferry":
            rating = 3
        case "Rail", "Tram", "Train", "Metro", "Electric kickscooter", "Electric bicycle", "Electric car":
            rating = 4
        case "Stationary", "Non-motorized", "Bicycle", "Pedestrian", "Walk", "Run", "Wheelchair", "Cross-country-skiing", "Snow":
            rating = 5
        default:
            rating = 0
        }
        
        return rating
    }
}
