//
//  TripDetailsViewController.swift
//  EcoTravel
//
//  Created by iosdev on 3.5.2021.
//

import UIKit

class TripDetailsViewController: UIViewController {

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var ecoRatingStackView: UIStackView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var trip: TripCoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Trip details"
        setDataToUI()
    }
    
    func setDataToUI() {
        guard let trip = trip else {
            fatalError("Trip value is nil")
        }
        
        let tripPropertyConverter = TripPropertyConverter()
        let activityName = tripPropertyConverter.convertFullActivityName(trip: trip)
        
        activityLabel.text = activityName
        
        let startTimeDate = tripPropertyConverter.convertTimestampToDateString(timestamp: Int(trip.timestampStart))
        let endTimeDate = tripPropertyConverter.convertTimestampToDateString(timestamp: Int(trip.timestampEnd))
        
        timeLabel.text = "\(startTimeDate) - \(endTimeDate)"
        co2Label.text = "Co2: \(String(format:"%.1f", trip.co2)) g"
        distanceLabel.text = "Distance: \(String(format:"%.1f", trip.distance)) m"
        speedLabel.text = "Avg. speed: \(String(format:"%.1f", trip.speed)) km/h"
        
        let rating = tripPropertyConverter.getEcoRatingForTripActivity(activityName: activityName)
        
        setEcoRatingImages(ratingView: ecoRatingStackView, rating: rating)
        
        detailsTextView.text = trip.metadata
    }
    
    func setEcoRatingImages(ratingView: UIStackView, rating: Int) {
        for i in 0..<rating {
            let ratingIconImageView = ratingView.subviews[i] as! UIImageView
            ratingIconImageView.image = UIImage(named: "EcoRatingIcon")
        }
    }
}
