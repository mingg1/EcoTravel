//
//  RouteDetailViewController.swift
//  EcoTravel
//
//  Created by iosdev on 21.4.2021.
//

import UIKit
import MapKit

class RouteDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var origin:CLLocationCoordinate2D?
    var destination:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if let origin = origin, let destination = destination {
            makeAnnotations(origin, destination)
            makeRoute(origin, destination)
        }
    }
    
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
            guard let unwrappedResponse = response else {
                return }
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
    
}
