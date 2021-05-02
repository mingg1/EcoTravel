//
//  EditTripViewController.swift
//  EcoTravel
//
//  Created by iosdev on 2.5.2021.
//

import UIKit
import MOPRIMTmdSdk

class EditTripViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var activityPickerView: UIPickerView!
    
    var trip: TripCoreData? = nil
    let activityOptions = ["Stationary", "Bicycle", "Walk", "Run", "Car", "Bus", "Tram", "Train", "Metro", "Plane", "Wheelchair", "Cross-country-skiing", "Electric kickscooter", "Electric bicycle", "Electric car", "Motorbike", "Scooter", "Ferry"]
    var selectedActivity = "Stationary"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityPickerView.delegate = self
        activityPickerView.dataSource = self
        
        self.navigationItem.title = "Edit trip"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedActivity = activityOptions[row]
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        var fullActivityName = ""
        switch selectedActivity {
        case "Stationary":
            fullActivityName = "stationary"
        case "Bicycle":
            fullActivityName = "non-motorized/bicycle"
        case "Walk":
            fullActivityName = "non-motorized/pedestrian/walk"
        case "Run":
            fullActivityName = "non-motorized/pedestrian/run"
        case "Car":
            fullActivityName = "motorized/road/car"
        case "Bus":
            fullActivityName = "motorized/road/bus"
        case "Tram":
            fullActivityName = "motorized/rail/tram"
        case "Train":
            fullActivityName = "motorized/rail/train"
        case "Metro":
            fullActivityName = "motorized/rail/metro"
        case "Plane":
            fullActivityName = "motorized/air/plane"
        case "Wheelchair":
            fullActivityName = "non-motorized/wheelchair"
        case "Cross-country-skiing":
            fullActivityName = "non-motorized/snow/cross-country-skiing"
        case "Electric kickscooter":
            fullActivityName = "motorized/road/kickscooter/electric"
        case "Electric bicycle":
            fullActivityName = "motorized/road/bicycle/electric"
        case "Electric car":
            fullActivityName = "motorized/road/car/electric"
        case "Motorbike":
            fullActivityName = "motorized/road/motorbike"
        case "Scooter":
            fullActivityName = "motorized/road/scooter"
        case "Ferry":
            fullActivityName = "motorized/water/ferry"
        default:
            print("No activity name found")
        }
        
        let tripDate = Date(timeIntervalSince1970: Double(trip!.timestampStart) / 1000.0)
        
        TMDCloudApi.fetchData(tripDate, minutesOffset: 0).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
                if let error = task.error {
                    NSLog("fetchData Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchData result: %@", data)
                    
                    var tripActivity = TMDActivity()
                    
                    for fetchedTrip in data {
                        let fetchedTrip = fetchedTrip as! TMDActivity
                        if(fetchedTrip.activityId == self.trip?.activityId) {
                            tripActivity = fetchedTrip
                        }
                    }
                    self.updateActivity(activity: tripActivity, newLabel: fullActivityName)
                }
            }
        }
    }
    
    func updateActivity(activity: TMDActivity, newLabel: String) {
        
        TMDCloudApi.correctActivity(activity, withLabel: newLabel).continueOnSuccessWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
                if let error = task.error {
                    NSLog("correctActivity Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("correctActivity result: %@", data)
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
