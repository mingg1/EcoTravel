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
        
        let tripPropertyConverter = TripPropertyConverter()
        let activityName = tripPropertyConverter.convertFullActivityName(trip: trip)
        
        cell.activityLabel.text = activityName
        
        let startTimeDate = tripPropertyConverter.convertTimestampToDateString(timestamp: Int(trip.timestampStart))
        
        cell.startTimeLabel.text = "\(startTimeDate) -"
        
        let endTimeDate = tripPropertyConverter.convertTimestampToDateString(timestamp: Int(trip.timestampEnd))
        
        cell.endTimeLabel.text = endTimeDate
        cell.co2Label.text = "Co2: \(String(format:"%.1f", trip.co2)) g"
        cell.distanceLabel.text = "Distance: \(String(format:"%.1f", trip.distance)) m"
        cell.speedLabel.text = "Avg. speed: \(String(format:"%.1f", trip.speed)) km/h"
        
        let rating = tripPropertyConverter.getEcoRatingForTripActivity(activityName: activityName)
        
        setEcoRatingImages(cell: cell, rating: rating)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tripDetailsViewController = storyboard?.instantiateViewController(identifier: "tripDetailsViewController") as? TripDetailsViewController {
            guard let trip = self.fetchedResultsController?.object(at: indexPath) else {
                fatalError("Trip not found from fetched results controller")
            }
            tripDetailsViewController.trip = trip
            navigationController?.pushViewController(tripDetailsViewController, animated: true)
        }
    }
    
    func setEcoRatingImages(cell: TripsTableViewCell, rating: Int) {
        for i in 0...4 {
            let ratingIconImageView = cell.ecoRatingStackView.subviews[i] as! UIImageView
            ratingIconImageView.image = UIImage(named: "EcoRatingIconEmpty")
        }
        
        for i in 0..<rating {
            let ratingIconImageView = cell.ecoRatingStackView.subviews[i] as! UIImageView
            ratingIconImageView.image = UIImage(named: "EcoRatingIcon")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FetchAndStoreData().fetchUsersTrips()
    }
}
