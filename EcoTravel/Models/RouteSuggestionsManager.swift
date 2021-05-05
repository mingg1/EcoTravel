//
//  RouteSuggestionsManager.swift
//  EcoTravel
//
//  Created by iosdev on 28.4.2021.
//

import Foundation
import MapKit
import Polyline

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

func timeFormatter(time:String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let formattedTime = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)!/1000))
    return formattedTime
}

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
    default:
        return ""
    }
}

class ModePolyline : MKPolyline {
    var color: UIColor?
}

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
    default:
        return .darkGray
    }
}

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

func setRegion (_ mapView:MKMapView, _ originCoordinate:CLLocationCoordinate2D, _ destCoordinate:CLLocationCoordinate2D){
    
    let newDistance = CLLocation(latitude: originCoordinate.latitude, longitude: originCoordinate.longitude).distance(from: CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude))
    let region = MKCoordinateRegion(center: originCoordinate, latitudinalMeters: newDistance*5, longitudinalMeters: newDistance*4)
    let adjustRegion = mapView.regionThatFits(region)
    mapView.setRegion(adjustRegion, animated:true)
    mapView.showAnnotations(mapView.annotations, animated: true)

//    let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.5)
//    let coordinateRegion = MKCoordinateRegion(center: coordinate, span:span)
//    mapView.setRegion(coordinateRegion,animated: true)
}

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

class UILabelPadding: UILabel {
    let padding = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}

func generateRoute(_ mapView:MKMapView, legs:[Legs]) {
    for leg in legs {
        let polyLine = Polyline(encodedPolyline: leg.legGeometry.points)
        let decodedCoordinates : Array<CLLocationCoordinate2D> = polyLine.coordinates!
        let polylineView = ModePolyline(coordinates: decodedCoordinates, count: decodedCoordinates.count)
        polylineView.color = setColor(leg.mode)
        mapView.addOverlay(polylineView)
    }
}

func generateImageView(imgName: String, superView:UIStackView, mode:String, size:Int) {
    let imgView = UIImageView()
    imgView.image = UIImage(systemName: imgName)
    imgView.frame.size.width = CGFloat(size)
    imgView.frame.size.height = CGFloat(size)
    imgView.tintColor = setColor(mode)
    superView.addArrangedSubview(imgView)
    imgView.setContentHuggingPriority(.required, for: .horizontal)
}

func generateStackView(axis:NSLayoutConstraint.Axis, distribution:UIStackView.Distribution, alignment:UIStackView.Alignment, spacing:CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.distribution  = distribution
    stackView.alignment = alignment
    stackView.spacing = spacing
    return stackView
}

func generateBoldTextLabel(text:String,size:CGFloat) -> UILabel {
    let textLabel = UILabel()
    textLabel.text = text
    textLabel.font = UIFont.boldSystemFont(ofSize: size)
    return textLabel
}
