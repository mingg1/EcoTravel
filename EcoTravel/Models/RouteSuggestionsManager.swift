import Foundation
import MapKit
import Polyline

/**
 * Class that handles data from GraphQL query to show them properly on the screens
 * Author Minji Choi
 * since 2021-04-24
 */
class RouteSuggestionsManager{
    /**
     * convert duration time
     * - Parameter duration: duration in milliseconds
     * - Returns: duration in minutes
     */
    func durationText(duration:String) -> String {
        var durationInMin = Int(ceil(Double(duration)! / 60))
        var durationText: String
        if (durationInMin > 60){
            let durationHour = Int(durationInMin / 60)
            durationInMin = durationInMin - (60 * durationHour)
            durationText = String(durationHour) + " h " + String(durationInMin) + " min"
        } else {
            durationText = String(durationInMin) + " min"
        }
        return durationText
    }
    
    /**
     * convert time in hour and minute format
     * - Parameter time: time in milliseconds
     * - Returns: time converted by date formatter
     */
    func timeFormatter(time:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)!/1000))
        return formattedTime
    }
    
    /**
     * set a system name of an image view with the transportation methods
     * - Parameter mode: name of transport mode
     * - Returns: system name of an image view
     */
    func setModeImgName(mode:String) -> String {
        switch mode {
        case "WALK":
            return "figure.walk"
        case "BUS":
            return "bus"
        case "TRAM":
            return "tram"
        case "RAIL":
            return "tram"
        case "SUBWAY":
            return"tram"
        case "AIRPLANE":
            return"airplane"
        default:
            return ""
        }
    }
    
    /**
     * set color depending on the transport mode
     * - Parameter mode: name of the transport mode
     * - Returns: color of the mode
     */
    func setColor(_ mode: String) -> UIColor {
        switch mode {
        case "WALK":
            return UIColor(red: 77/255.0, green: 195/255.0, blue: 33/255.0, alpha: 1)
        case "BUS":
            return UIColor(red: 30/255.0, green: 96/255.0, blue: 145/255.0, alpha: 1)
        case "TRAM":
            return UIColor(red: 249/255.0, green: 199/255.0, blue: 79/255.0, alpha: 1)
        case "RAIL":
            return UIColor(red: 90/255.0, green: 24/255.0, blue: 154/255.0, alpha: 1)
        case "SUBWAY":
            return UIColor(red: 252/255.0, green: 119/255.0, blue: 83/255.0, alpha: 1)
        case "AIRPLANE":
            return UIColor(red: 0/255.0, green: 180/255.0, blue: 216/255.0, alpha: 1)
        default:
            return .darkGray
        }
    }
    
    /**
     * make annotations on the map
     * - Parameter mapView: map view that will show the annotations
     * - Parameter coordinate: coordinate of the place
     * - Parameter isOrigin: checking if the place is the origin or not
     * - Parameter destTitle: name of the destination
     */
    func makeAnnotation(_ mapView:MKMapView, _ coordinate:CLLocationCoordinate2D, isOrigin: Bool, destTitle: String?){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        if (isOrigin){
            //setRegion(mapView, annotation.coordinate)
            annotation.title = "Current location"
        } else {
            annotation.title = destTitle
        }
    }
    
    /**
     * set the region shown on the map
     * - Parameter mapView: map view
     * - Parameter originCoordinate: coordinate of the origin
     * - Parameter destCoordinate: coordinate of the destination
     */
    func setRegion (_ mapView:MKMapView, _ originCoordinate:CLLocationCoordinate2D, _ destCoordinate:CLLocationCoordinate2D){
        
        let newDistance = CLLocation(latitude: originCoordinate.latitude, longitude: originCoordinate.longitude).distance(from: CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude))
        let region = MKCoordinateRegion(center: originCoordinate, latitudinalMeters: newDistance*5, longitudinalMeters: newDistance*4)
        let adjustRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustRegion, animated:true)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    /**
     * set the direction of origin and destination on the map
     * - Parameter mapView: map view that will set the origin and destination
     * - Parameter originCoordinate: coordinate of the origin
     * - Parameter destCoordinate: coordinate of the destination
     */
    func makeRoute(_ mapView:MKMapView, _ originCoordinate:CLLocationCoordinate2D, _ destCoordinate:CLLocationCoordinate2D){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: originCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destCoordinate, addressDictionary: nil))
     
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let unwrappedResponse = response else { return }
            for route in unwrappedResponse.routes {
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        setRegion(mapView, originCoordinate, destCoordinate)
    }

    /**
     * make a polyline on the map
     * - Parameter mapView: mapview that will show the polyline
     * - Parameter legs: a list of legs
     */
    func generateRoute(_ mapView:MKMapView, legs:[Legs]) {
        for leg in legs {
            let polyLine = Polyline(encodedPolyline: leg.legGeometry.points)
            let decodedCoordinates : Array<CLLocationCoordinate2D> = polyLine.coordinates!
            let polylineView = ModePolyline(coordinates: decodedCoordinates, count: decodedCoordinates.count)
            polylineView.color = setColor(leg.mode)
            mapView.addOverlay(polylineView)
        }
    }
}

/// polyline with customized color
class ModePolyline : MKPolyline {
    var color: UIColor?
}
