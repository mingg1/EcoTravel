//
//  Statistic.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 28.4.2021.
//

import Foundation

// Statistic class that is used as a temporary data structure for the statistic objects that are fetched from the API
class Statistic {
    
    let activity: String
    let userCo2: Double
    let userDistance: Double
    let userDuration: Double
    let userLegs: Int
    let dateString: String
    
    init(activity: String, userCo2: Double, userDistance: Double, userDuration: Double, userLegs: Int, dateString: String) {
        self.activity = activity
        self.userCo2 = userCo2
        self.userDistance = userDistance
        self.userDuration = userDuration
        self.userLegs = userLegs
        self.dateString = dateString
    }
}
