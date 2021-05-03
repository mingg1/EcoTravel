//
//  EditTripViewController.swift
//  EcoTravel
//
//  Created by iosdev on 2.5.2021.
//

import UIKit
import MOPRIMTmdSdk

class EditTripViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var activityPickerView: UIPickerView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var trip: TripCoreData?
    let activityOptions = ["Stationary", "Bicycle", "Walk", "Run", "Car", "Bus", "Tram", "Train", "Metro", "Plane", "Wheelchair", "Cross-country-skiing", "Electric kickscooter", "Electric bicycle", "Electric car", "Motorbike", "Scooter", "Ferry"]
    var saveItem: UIBarButtonItem?
    var doneItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityPickerView.delegate = self
        activityPickerView.dataSource = self
        detailsTextView.delegate = self
        
        self.navigationItem.title = "Edit trip"
        
        saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        if let saveItem = saveItem {
            saveItem.style = .done
        }
        
        doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        self.navigationItem.rightBarButtonItem = saveItem
        
        guard let trip = trip else {
            fatalError("Trip value is nil")
        }
        
        let activityName = TripPropertyConverter().convertFullActivityName(trip: trip)
        
        let currentActivityIndex = activityOptions.firstIndex(of: activityName)
        if let currentActivityIndex = currentActivityIndex {
            activityPickerView.selectRow(currentActivityIndex, inComponent: 0, animated: false)
        }
        
        detailsTextView.text = trip.metadata
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
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        var fullActivityName = ""
        switch activityOptions[activityPickerView.selectedRow(inComponent: 0)] {
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
        
        let activityDetails = detailsTextView.text ?? ""
        
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
                    self.updateActivityAndMetadata(activity: tripActivity, newLabel: fullActivityName, metadata: activityDetails)
                }
            }
        }
    }
    
    func updateActivityAndMetadata(activity: TMDActivity, newLabel: String, metadata: String) {
        
        TMDCloudApi.updateActivity(activity, withLabel: newLabel, withMetadata: metadata).continueOnSuccessWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
                if let error = task.error {
                    NSLog("annotateActivity Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("annotateActivity result: %@", data)
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc func doneButtonTapped() {
        detailsTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = saveItem
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = doneItem
    }
}
