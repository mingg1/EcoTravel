//
//  TripsTableViewController.swift
//  EcoTravel
//
//  Created by Tuomas Bergholm on 28.4.2021.
//

import UIKit
import CoreData

// The ViewController for the trips list screen
class TripsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<TripCoreData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The previous trips are fetched from Core Data with fetchedResultsController
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
        
        // The storyboard, navigationController and trip are passed to the table view cell for later use
        cell.storyboard = storyboard
        cell.navigationController = navigationController
        cell.trip = trip
        
        // The activityName of the trip is converted to a more readable, shorter version
        let tripPropertyConverter = TripPropertyConverter()
        let activityName = tripPropertyConverter.convertFullActivityName(trip: trip)
        
        cell.activityLabel.text = activityName
        
        // The timestamps of the trip are converted to date strings
        let startTimeDate = tripPropertyConverter.convertTimestampToDateString(timestamp: Int(trip.timestampStart))
        
        cell.startTimeLabel.text = "\(startTimeDate) -"
        
        let endTimeDate = tripPropertyConverter.convertTimestampToDateString(timestamp: Int(trip.timestampEnd))
        
        cell.endTimeLabel.text = endTimeDate
        cell.co2Label.text = "Co2: \(String(format:"%.1f", trip.co2)) g"
        cell.distanceLabel.text = "Distance: \(String(format:"%.1f", trip.distance)) m"
        cell.speedLabel.text = "Avg. speed: \(String(format:"%.1f", trip.speed)) km/h"
        
        // The eco-rating is determined based on the activity
        let rating = tripPropertyConverter.getEcoRatingForTripActivity(activityName: activityName)
        
        setEcoRatingImages(cell: cell, rating: rating)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When a table view cell is tapped, a transition to the details screen is performed
        if let tripDetailsViewController = storyboard?.instantiateViewController(identifier: "tripDetailsViewController") as? TripDetailsViewController {
            guard let trip = self.fetchedResultsController?.object(at: indexPath) else {
                fatalError("Trip not found from fetched results controller")
            }
            tripDetailsViewController.trip = trip
            navigationController?.pushViewController(tripDetailsViewController, animated: true)
        }
    }
    
    // Function for setting the eco-rating images to the cells based on the eco-rating
    func setEcoRatingImages(cell: TripsTableViewCell, rating: Int) {
        // First all the icons are reset to empty versions due to activity editing consequences
        for i in 0...4 {
            let ratingIconImageView = cell.ecoRatingStackView.subviews[i] as! UIImageView
            ratingIconImageView.image = UIImage(named: "EcoRatingIconEmpty")
        }
        
        // Based on the eco-rating, the right amount of icons are set
        for i in 0..<rating {
            let ratingIconImageView = cell.ecoRatingStackView.subviews[i] as! UIImageView
            ratingIconImageView.image = UIImage(named: "EcoRatingIcon")
        }
    }
    
    // MARK: - NSFetchedResultsController delegate
    
    // When the trips data is updated, the table view data is reloaded
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        tableView.reloadData()
    }
}
