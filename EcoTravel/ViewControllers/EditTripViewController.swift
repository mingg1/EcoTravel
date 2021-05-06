//
//  EditTripViewController.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 2.5.2021.
//

import UIKit
import MOPRIMTmdSdk

/// ViewController for the edit trip screen
class EditTripViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var activityPickerView: UIPickerView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var trip: TripCoreData?
    let activityOptions = ["Stationary", "Bicycle", "Walk", "Run", "Car", "Bus", "Tram", "Train", "Metro", "Plane", "Wheelchair", "Cross-country-skiing", "Electric kickscooter", "Electric bicycle", "Electric car", "Motorbike", "Scooter", "Ferry"]
    var saveButton: UIBarButtonItem?
    var doneButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityPickerView.delegate = self
        activityPickerView.dataSource = self
        detailsTextView.delegate = self
        
        self.navigationItem.title = "Edit trip"
        
        // Navigation bar buttons for save and done functions are created
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        if let saveButton = saveButton {
            saveButton.style = .done
        }
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        self.navigationItem.rightBarButtonItem = saveButton
        
        guard let trip = trip else {
            fatalError("Trip value is nil")
        }
        
        // The activityName of the trip is converted to a more readable, shorter version
        let activityName = TripPropertyConverter().convertFullActivityName(trip: trip)
        
        // If the picker view for selecting the correct activity includes the current activity, the picker view will be set by default to that
        let currentActivityIndex = activityOptions.firstIndex(of: activityName)
        if let currentActivityIndex = currentActivityIndex {
            activityPickerView.selectRow(currentActivityIndex, inComponent: 0, animated: false)
        }
        
        detailsTextView.text = trip.metadata
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityOptions.count
    }
    
    // MARK: - Picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityOptions[row]
    }
    
    // MARK: - Button event handlers and functions
    
    // Function for tapping the save button
    @objc func saveButtonTapped() {
        // The save button is disabled after the user has tapped it
        saveButton?.isEnabled = false
        
        // The selected new activity name is converted to the full activity name for uploading to the API
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
        
        // The timestamp of the trip is converted to a date
        let tripDate = Date(timeIntervalSince1970: Double(trip!.timestampStart) / 1000.0)
        
        // The trips of the specific date are fetched from the API to find a reference to the original trip that is going to be edited
        TMDCloudApi.fetchData(tripDate, minutesOffset: 0).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                if let error = task.error {
                    NSLog("fetchData Error: %@", error.localizedDescription)
                    
                    // If a network operation error occurs in fetching the data, the user will be notified about it with an alert
                    let alert = UIAlertController(title: "Error in updating", message: "An error occurred in updating the data.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.saveButton?.isEnabled = true
                }
                else if let data = task.result {
                    NSLog("fetchData result: %@", data)
                    
                    var tripActivity = TMDActivity()
                    
                    // The specific trip is searched from the results by comparing the activityIds
                    for fetchedTrip in data {
                        let fetchedTrip = fetchedTrip as! TMDActivity
                        if(fetchedTrip.activityId == self.trip?.activityId) {
                            tripActivity = fetchedTrip
                        }
                    }
                    // The trip is updated with new data to the API
                    self.updateActivityAndMetadata(activity: tripActivity, newLabel: fullActivityName, metadata: activityDetails)
                }
            }
        }
    }
    
    // Function for updating the new activity and metadata of it to the API
    func updateActivityAndMetadata(activity: TMDActivity, newLabel: String, metadata: String) {
        
        TMDCloudApi.updateActivity(activity, withLabel: newLabel, withMetadata: metadata).continueOnSuccessWith { (task) -> Any? in
            DispatchQueue.main.async {
                if let error = task.error {
                    NSLog("annotateActivity Error: %@", error.localizedDescription)
                    
                    // If a network operation error occurs in updating the data, the user will be notified about it with an alert
                    let alert = UIAlertController(title: "Error in updating", message: "An error occurred in updating the data.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.saveButton?.isEnabled = true
                }
                else if let data = task.result {
                    NSLog("annotateActivity result: %@", data)
                    
                    // After the update is complete, the trips are fetched from the API and stored to Core Data again and the app returns to the trips list
                    FetchAndStoreData().fetchUsersTrips()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // Function for tapping the done button
    @objc func doneButtonTapped() {
        // The keyboard is dismissed
        detailsTextView.resignFirstResponder()
        // The navigation bar button is replaced with the save button
        navigationItem.rightBarButtonItem = saveButton
    }
    
    // MARK: - Text view delegate
    
    // Function for beginning editing the text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        // The navigation bar button is replaced with the done button
        navigationItem.rightBarButtonItem = doneButton
    }
}
