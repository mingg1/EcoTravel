//
//  LocationSearchTable.swift
//  EcoTravel
//
//  Created by iosdev on 21.4.2021.
//

import UIKit
import MapKit

// Table view controller for displaying the search results
class LocationSearchTable: UITableViewController {
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Extension for UISearchResultsUpdating protocol function
extension LocationSearchTable: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

// Extension for table view data source functions
extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationSearchTableCell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        cell.detailTextLabel?.text = address
        return cell
    }
}

// Extension for table view delegate functions
extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
