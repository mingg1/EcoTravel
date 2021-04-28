//
//  Statistic.swift
//  EcoTravel
//
//  Created by iosdev on 28.4.2021.
//

import Foundation

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
