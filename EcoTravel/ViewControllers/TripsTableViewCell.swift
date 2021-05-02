//
//  TripsTableViewCell.swift
//  EcoTravel
//
//  Created by iosdev on 28.4.2021.
//

import UIKit
import MOPRIMTmdSdk

class TripsTableViewCell: UITableViewCell {
    
    var storyboard: UIStoryboard? = nil
    var navigationController: UINavigationController? = nil
    var trip: TripCoreData? = nil

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(identifier: "editTripViewController") as? EditTripViewController {
            viewController.trip = trip
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
