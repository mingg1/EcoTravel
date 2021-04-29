//
//  RouteSuggestionsManager.swift
//  EcoTravel
//
//  Created by iosdev on 28.4.2021.
//

import Foundation
import MapKit

func durationText(duration:String) -> String {
    let durationInMin = Int(ceil(Double(duration)! / 60))
    let durationText = String(durationInMin) + " min"
    return durationText
}

func timeFormatter(time:String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let formattedTime = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)!/1000))
    return formattedTime
}

func setModeImgName(mode:String) -> String {
    switch mode {
    case "WALK":
        return "figure.walk"
    case "BUS":
        return "bus"
    case "TRAM":
        return "tram"
    case "RAIL":
        return "tram"
    case "SUBWAY":
        return"tram"
    default:
        return ""
    }
}

class ModePolyline : MKPolyline {
    var color: UIColor?
}

func setColor(_ mode: String) -> UIColor {
    switch mode {
    case "WALK":
        return .green
    case "BUS":
        return .blue
    case "TRAM":
        return .yellow
    case "RAIL":
        return .purple
    case "SUBWAY":
        return .orange
    default:
        return .red
    }
}
