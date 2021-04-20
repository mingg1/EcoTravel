//
//  HomeViewController.swift
//  EcoTravel
//
//  Created by iosdev on 15.4.2021.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        let location = CLLocation(latitude: 60.16, longitude: 24.93)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          self.navigationController?.navigationBar.isHidden = false
    }
    
    func startLocationUpdates() {
        if CLLocationManager.locationServicesEnabled() {
            print("Location latitude: \(locationManager.location?.coordinate.latitude ?? 0.0)")
            locationManager.distanceFilter = 100
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
        mapView.setCenter(locations[0].coordinate, animated: true)
    }
    
    // MARK: - Map view delegate
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("User location updated")
    }
}
