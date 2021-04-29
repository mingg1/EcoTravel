//
//  ItineraryTableCell.swift
//  EcoTravel
//
//  Created by iosdev on 26.4.2021.
//

import UIKit

class ItineraryTableCell: UITableViewCell {
    
    static let identifier = "ItineraryCell"
    static func nib() -> UINib {
        return UINib(nibName: "ItineraryTableCell", bundle: nil)
    }
    
    public func configure(route:UIStackView, time:String, duration:String){
        print("route: ",route)
        for view in routeStackView.subviews{
            view.removeFromSuperview()
        }
        self.routeStackView.addArrangedSubview(route)
        routeStackView.setContentHuggingPriority(.required, for: .horizontal)
//        self.transportationIcon.image = UIImage(systemName: transportationIcon)
//        self.line.text = line
        self.time.text = time
        self.duration.text = duration
    }
    
    @IBOutlet weak var transportationIcon: UIImageView!
    
    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var routeStackView: UIStackView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
