//
//  RouteSuggestionsViewController.swift
//  EcoTravel
//
//  Created by iosdev on 15.4.2021.
//

import UIKit
import MapKit
import Polyline

class RouteSuggestionsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationField: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    
    let data = ItineraryManager()
    
    // coordinate of the origin (default: Kamppi)
    var origin = CLLocationCoordinate2D(latitude: 60.168992, longitude: 24.932366)
    // coordinate of the destination (default: Kaivopuisto)
    var destination = CLLocationCoordinate2D(latitude: 60.15638994476689, longitude: 24.9572360295062)
    // title for the destination annotation
    var destinationTitle : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeShadow()
        transparentNavigationBar()
        destinationField.text = destinationTitle
        
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        data.delegate = self
        
        tableView.register(ItineraryTableCell.nib(), forCellReuseIdentifier: ItineraryTableCell.identifier)
        
        data.fetchItinerary(originLat: Double(origin.latitude), originLon: Double(origin.longitude), destLat: Double(destination.latitude), destLon: Double(destination.longitude))
        
        makeRoute(origin, destination)
        makeAnnotation(origin, isOrigin: true)
        makeAnnotation(destination, isOrigin: false)
    }

    // MARK: - Functions for setting UI elements
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func makeShadow(){
        backBtn.layer.shadowColor = UIColor.black.cgColor
        backBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        backBtn.layer.shadowRadius = 0.8
        backBtn.layer.shadowOpacity = 0.5
    }
    
    func transparentNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "Route option(s)"
        headerLabel.backgroundColor = UIColor.white
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itineraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itinerary = data.itineraries[indexPath.row]

        let duration = durationText(duration: itinerary.duration)
        let startTime = timeFormatter(time: itinerary.legs[0].startTime)
        let arrivalTime = timeFormatter(time: itinerary.legs.last!.endTime)
        let durationTime = startTime + " - " + arrivalTime
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 6
        
        for leg in itinerary.legs{
           
            let modeImgName = setModeImgName(mode: leg.mode)
            let routeShortName = leg.trip?.routeShortName
            let modeImgView = UIImageView()
            let modeImg = UIImage(systemName: modeImgName)
            modeImgView.image = modeImg
            modeImgView.frame.size.width = 24
            modeImgView.frame.size.height = 24
            let routeshortNameLabel = UILabel()
            routeshortNameLabel.text = routeShortName
            stackView.addArrangedSubview(modeImgView)
            stackView.addArrangedSubview(routeshortNameLabel)
        }
        print(stackView.subviews.count)
        let itineraryCell = tableView.dequeueReusableCell(withIdentifier: ItineraryTableCell.identifier, for: indexPath) as! ItineraryTableCell
        itineraryCell.configure(route:stackView, time: durationTime, duration: duration)
        
        
        return itineraryCell
    }
    
    // height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= data.itineraries.count {
            return 0
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected", indexPath.row)
        let itinerary = data.itineraries[indexPath.row]
        self.mapView.removeOverlays(self.mapView.overlays)
        print("data", itinerary.legs.count)
        for leg in itinerary.legs {
            let polyLine = Polyline(encodedPolyline: leg.legGeometry.points)
            let decodedCoordinates : Array<CLLocationCoordinate2D> = polyLine.coordinates!
            let polylineView = ModePolyline(coordinates: decodedCoordinates, count: decodedCoordinates.count)
            polylineView.color = setColor(leg.mode)
            self.mapView.addOverlay(polylineView)
        }

        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? RouteDetailViewController{
            detailVC.origin = origin
            detailVC.destination = destination
        }
    }
}
// MARK: - MKMapViewDelegate

extension RouteSuggestionsViewController:MKMapViewDelegate{
    
    func makeAnnotation(_ coordinate:CLLocationCoordinate2D, isOrigin: Bool){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        if (isOrigin){
            setRegion(annotation.coordinate)
            annotation.title = "Current location"
        } else {
            annotation.title = destinationTitle
        }
    }

    func setRegion (_ coordinate: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.5)
        let coordinateRegion = MKCoordinateRegion(center: coordinate, span:span)
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
        setRegion(destCoordinate)
    }
  
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (overlay as? ModePolyline)?.color
        renderer.lineWidth = 4.7
        return renderer
    }

}


// MARK: - ItineraryManagerDelegate

extension RouteSuggestionsViewController:ItineraryManagerDelegate{
    func didUpdateData(_ itineraryManager: ItineraryManager, data: [Itineraries]) {
        self.tableView.reloadData()
        
        let firstIndexPath = IndexPath(row: 0, section: 0)
        //self.tableView(at: firstIndexPath, animated: false, scrollPosition: .none)
        self.tableView(self.tableView, didSelectRowAt: firstIndexPath)
    }
}
