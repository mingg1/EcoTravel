//
//  HomeViewController.swift
//  EcoTravel
//
//  Created by iosdev on 15.4.2021.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search functionality initialization
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "locationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        // Request authorization for location
        startStopRequestAuthorization(manager: locationManager, status: locationManager.authorizationStatus)
        
        // Map view initialization
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        let location = CLLocation(latitude: 60.16, longitude: 24.93)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func startLocationUpdates() {
        if CLLocationManager.locationServicesEnabled() {
            print("Location latitude: \(locationManager.location?.coordinate.latitude ?? 0.0)")
            locationManager.distanceFilter = 50
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        } else {
            print("Location services not available")
        }
    }
    
    // MARK: - Location manager delegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        startStopRequestAuthorization(manager: manager, status: manager.authorizationStatus)
    }
    
    func startStopRequestAuthorization(manager: CLLocationManager, status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            manager.stopUpdatingLocation()
            manager.delegate = nil
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("Enabling location services")
            manager.delegate = self
            self.startLocationUpdates()
            
        @unknown default:
            fatalError("Authorization status unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location did update: \(locations)")
    }
    
    // MARK: - Map view delegate
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("User location updated")
        mapView.setCenter(userLocation.coordinate, animated: true)
    }
}

// Extension for HandleMapSearch protocol function
extension HomeViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
