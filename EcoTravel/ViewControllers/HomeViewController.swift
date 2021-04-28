//
//  HomeViewController.swift
//  EcoTravel
//
//  Created by iosdev on 15.4.2021.
//

import UIKit
import MapKit
import MOPRIMTmdSdk
import CoreLocation
import CoreMotion

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let motionActivityManager = CMMotionActivityManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    var searchedLocationDisplayed = false
    var currentLocationButton: UIButton? = nil
    var routeSuggestionsButton: UIButton? = nil
    
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
        
        // Request permissions for motion
        askMotionPermissions()
        
        // Map view initialization
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        let location = CLLocation(latitude: 60.16, longitude: 24.93)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        createCurrentLocationButton()
        createRouteSuggestionsButton()
        
        TMD.start()
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
        
        if #available(iOS 14.0, *) {
            let preciseLocationAuthorized = (manager.accuracyAuthorization == .fullAccuracy)
            if preciseLocationAuthorized == false {
                manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "tmd.AccurateLocationPurpose")
                // Note that this will only ask for TEMPORARY precise location.
                // You should make sure to ask your user to keep the Precise Location turned on in the Settings.
            }
        } else {
            // No need to ask for precise location before iOS 14
        }
    }
    
    func startStopRequestAuthorization(manager: CLLocationManager, status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            
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
    
    func askMotionPermissions() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                print("received motion activity")
                self.motionActivityManager.stopActivityUpdates()
            }
        }
    }
    
    // MARK: - Map view delegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("User location updated")
        if(!searchedLocationDisplayed) {
            mapView.setCenter(userLocation.coordinate, animated: true)
        }
    }
    
    // MARK: - Current location button functions
    
    func createCurrentLocationButton() {
        currentLocationButton = UIButton(type: UIButton.ButtonType.system)
        
        guard let currentLocationButton = currentLocationButton else {
            fatalError("Current location button does not exist")
        }
        
        currentLocationButton.backgroundColor = UIColor.systemBlue
        currentLocationButton.setTitle("Current location", for: UIControl.State.normal)
        currentLocationButton.tintColor = UIColor.white
        currentLocationButton.addTarget(self, action: #selector(self.currentLocationButtonTapped), for: .touchUpInside)
        
        mapView.addSubview(currentLocationButton)
        
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentLocationButton.widthAnchor.constraint(equalToConstant: 130),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 30),
            currentLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            currentLocationButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20)
        ])
    }
    
    @objc func currentLocationButtonTapped(_ sender: UIButton!) {
        if let currentLocation = locationManager.location?.coordinate {
            let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(coordinateRegion, animated: true)
            
            if(searchedLocationDisplayed) {
                routeSuggestionsButton?.removeFromSuperview()
                mapView.removeAnnotations(mapView.annotations)
            }
            
            searchedLocationDisplayed = false
        } else {
            print("Current location not available")
        }
    }
    
    // MARK: - Route suggestions button functions
    
    func createRouteSuggestionsButton() {
        routeSuggestionsButton = UIButton(type: UIButton.ButtonType.system)
        
        guard let routeSuggestionsButton = routeSuggestionsButton else {
            fatalError("Route suggestions button does not exist")
        }
        
        routeSuggestionsButton.backgroundColor = UIColor.systemGreen
        routeSuggestionsButton.setTitle("Route Suggestions", for: UIControl.State.normal)
        routeSuggestionsButton.tintColor = UIColor.white
        routeSuggestionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        routeSuggestionsButton.addTarget(self, action: #selector(self.routeSuggestionsButtonTapped), for: .touchUpInside)
    }
    
    func displayRouteSuggestionsButton() {
        if let routeSuggestionsButton = routeSuggestionsButton {
            mapView.addSubview(routeSuggestionsButton)
            
            routeSuggestionsButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                routeSuggestionsButton.heightAnchor.constraint(equalToConstant: 50),
                routeSuggestionsButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 100),
                routeSuggestionsButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -100),
                routeSuggestionsButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50)
            ])
        }
    }
    
    @objc func routeSuggestionsButtonTapped(_ sender: UIButton!) {
        performSegue(withIdentifier: "toRouteSuggestions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let routeSuggestionsVC = segue.destination as? RouteSuggestionsViewController {
            
            if let originCoordinate = locationManager.location?.coordinate {
                routeSuggestionsVC.origin = CLLocationCoordinate2D(latitude: originCoordinate.latitude, longitude: originCoordinate.longitude)
            }
            
            if let destinationCoordinate = selectedPin?.coordinate {
                routeSuggestionsVC.destination = CLLocationCoordinate2D(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
            }
            
            if let placeName = selectedPin?.name {
                routeSuggestionsVC.destinationTitle = placeName
            }
        }
    }
}

// Extension for HandleMapSearch protocol function
extension HomeViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        searchedLocationDisplayed = true
        displayRouteSuggestionsButton()
        
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
