//
//  RouteSuggestionsViewController.swift
//  EcoTravel
//
//  Created by iosdev on 15.4.2021.
//

import UIKit
import MapKit

class RouteSuggestionsViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // Kamppi
    let origin = CLLocationCoordinate2D(latitude: 60.168992, longitude: 24.932366)
    // Kaivopuisto
    let destination = CLLocationCoordinate2D(latitude: 60.15638994476689, longitude: 24.9572360295062)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        //        mapView.showsUserLocation = true
        makeRoute(origin, destination)
        makeAnnotations(origin, destination)
    }
    
    // MARK: - MKMapViewDelegate
    
    func makeAnnotations(_ originCoordinate:CLLocationCoordinate2D, _ destCoordinate:CLLocationCoordinate2D){
        let originAnnotation = MKPointAnnotation()
        let destinationAnnotation = MKPointAnnotation()
        originAnnotation.coordinate = originCoordinate
        mapView.addAnnotation(originAnnotation)
        destinationAnnotation.coordinate = destCoordinate
        mapView.addAnnotation(destinationAnnotation)
        let coordinateRegion = MKCoordinateRegion(center: originAnnotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(coordinateRegion,animated: true)
    }
    
    func makeRoute(_ originCoordinate:CLLocationCoordinate2D, _ destCoordinate:CLLocationCoordinate2D){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: originCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destCoordinate, addressDictionary: nil))
        // request.requestsAlternateRoutes = false
        request.transportType = .any
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.orange
        return renderer
    }
    
    // MARK: - UITableViewDelegate
    
    let tempList = ["route 1"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "The most eco-friendly option(s)"
        headerLabel.backgroundColor = UIColor.white
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tempList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? RouteDetailViewController{
            detailVC.origin = origin
            detailVC.destination = destination
        }
        
    }
    
}
