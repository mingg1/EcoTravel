//
//  TripDetailsViewController.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 3.5.2021.
//

import UIKit

// ViewController for the trip details screen
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
    
    // Function for setting the trip data to the UI
    func setDataToUI() {
        guard let trip = trip else {
            fatalError("Trip value is nil")
        }
        
        // The activityName of the trip is converted to a more readable, shorter version
        let tripPropertyConverter = TripPropertyConverter()
        let activityName = tripPropertyConverter.convertFullActivityName(trip: trip)
        
        activityLabel.text = activityName
        
        // The timestamps of the trip are converted to date strings
        let startTimeDate = tripPropertyConverter.convertTimestampToDateString(timestamp: Int(trip.timestampStart))
        let endTimeDate = tripPropertyConverter.convertTimestampToDateString(timestamp: Int(trip.timestampEnd))
        
        timeLabel.text = "\(startTimeDate) - \(endTimeDate)"
        co2Label.text = "Co2: \(String(format:"%.1f", trip.co2)) g"
        distanceLabel.text = "Distance: \(String(format:"%.1f", trip.distance / 1000)) km"
        speedLabel.text = "Avg. speed: \(String(format:"%.1f", trip.speed)) km/h"
        
        // The eco-rating is determined based on the activity
        let rating = tripPropertyConverter.getEcoRatingForTripActivity(activityName: activityName)
        
        setEcoRatingImages(ratingView: ecoRatingStackView, rating: rating)
        
        detailsTextView.text = trip.metadata
    }
    
    // Function for setting the eco-rating images to the rating view based on the eco-rating
    func setEcoRatingImages(ratingView: UIStackView, rating: Int) {
        // Based on the eco-rating, the right amount of icons are set
        for i in 0..<rating {
            let ratingIconImageView = ratingView.subviews[i] as! UIImageView
            ratingIconImageView.image = UIImage(named: "EcoRatingIcon")
        }
    }
}
