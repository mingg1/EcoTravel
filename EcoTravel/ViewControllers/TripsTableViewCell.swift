//
//  TripsTableViewCell.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 28.4.2021.
//

import UIKit
import MOPRIMTmdSdk

/// Class for the custom trips table view cell
class TripsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var ecoRatingStackView: UIStackView!
    
    var storyboard: UIStoryboard?
    var navigationController: UINavigationController?
    var trip: TripCoreData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // When the edit button on the cell is tapped, a transition to the edit trip screen is done
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if let editTripViewController = storyboard?.instantiateViewController(identifier: "editTripViewController") as? EditTripViewController {
            editTripViewController.trip = trip
            navigationController?.pushViewController(editTripViewController, animated: true)
        }
    }
}
