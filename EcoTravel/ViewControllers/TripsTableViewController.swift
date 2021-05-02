//
//  TripsTableViewController.swift
//  EcoTravel
//
//  Created by iosdev on 28.4.2021.
//

import UIKit
import CoreData

class TripsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<TripCoreData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tripsRequest: NSFetchRequest<TripCoreData> = TripCoreData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestampStart", ascending: false)
        tripsRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: tripsRequest, managedObjectContext: AppDelegate.viewContext, sectionNameKeyPath: "originalActivity", cacheName: "tripsCache")
        
        fetchedResultsController!.delegate = self as NSFetchedResultsControllerDelegate
        try? fetchedResultsController?.performFetch()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController!.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController!.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "tripsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TripsTableViewCell else {
            fatalError("The dequeued cell is not an instance of TripsTableViewCell")
        }
        
        guard let trip = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Trip not found from fetched results controller")
        }
        
        cell.storyboard = storyboard
        cell.navigationController = navigationController
        cell.trip = trip
        
        var correctActivity: String
        if(trip.correctedActivity != "") {
            correctActivity = trip.correctedActivity ?? "No activity"
        } else {
            correctActivity = trip.originalActivity ?? "No activity"
        }
        
        var activityName: String
        switch correctActivity {
        case "unknown":
            activityName = "Unknown"
        case "stationary":
            activityName = "Stationary"
        case "non-motorized":
            activityName = "Non-motorized"
        case "non-motorized/bicycle":
            activityName = "Bicycle"
        case "non-motorized/pedestrian":
            activityName = "Pedestrian"
        case "non-motorized/pedestrian/walk":
            activityName = "Walk"
        case "non-motorized/pedestrian/run":
            activityName = "Run"
        case "motorized":
            activityName = "Motorized"
        case "motorized/road":
            activityName = "Motorized/road"
        case "motorized/road/car":
            activityName = "Car"
        case "motorized/road/bus":
            activityName = "Bus"
        case "motorized/rail":
            activityName = "Rail"
        case "motorized/rail/tram":
            activityName = "Tram"
        case "motorized/rail/train":
            activityName = "Train"
        case "motorized/rail/metro":
            activityName = "Metro"
        case "motorized/air/plane":
            activityName = "Plane"
        case "non-motorized/wheelchair":
            activityName = "Wheelchair"
        case "non-motorized/snow/cross-country-skiing":
            activityName = "Cross-country-skiing"
        case "motorized/road/kickscooter/electric":
            activityName = "Electric kickscooter"
        case "motorized/road/bicycle/electric":
            activityName = "Electric bicycle"
        case "motorized/road/car/electric":
            activityName = "Electric car"
        case "motorized/road/motorbike":
            activityName = "Motorbike"
        case "motorized/road/scooter":
            activityName = "Scooter"
        case "motorized/water/ferry":
            activityName = "Ferry"
        case "non-motorized/snow":
            activityName = "Snow"
        case "motorized/water":
            activityName = "Water"
        case "motorized/air":
            activityName = "Air"
        default:
            activityName = "No activity"
        }
        
        cell.activityLabel.text = "\(activityName)"
        
        let startTimeDate = Date(timeIntervalSince1970: Double(trip.timestampStart) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let formattedStartTimeDate = formatter.string(from: startTimeDate)
        
        cell.startTimeLabel.text = "Start: \(formattedStartTimeDate)"
        
        let endTimeDate = Date(timeIntervalSince1970: Double(trip.timestampEnd) / 1000.0)
        let formattedEndTimeDate = formatter.string(from: endTimeDate)
        
        cell.endTimeLabel.text = "End: \(formattedEndTimeDate)"
        cell.co2Label.text = "Co2: \(String(format:"%.1f", trip.co2)) g"
        cell.distanceLabel.text = "Distance: \(String(format:"%.1f", trip.distance)) m"
        cell.speedLabel.text = "Avg. speed: \(String(format:"%.1f", trip.speed)) km/h"
        
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FetchAndStoreData().fetchUsersTrips()
    }
}
