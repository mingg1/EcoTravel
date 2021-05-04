// View controller for the route suggestion
// Author: Minji Choi

import UIKit
import MapKit
import Polyline

class RouteSuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationField: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    
    let data = ItineraryManager()
    var selectedRow : Int?
    var selectedItinerary: Itineraries?
    
    // coordinate of the origin receieved from the home view (default: Kamppi)
    var origin = CLLocationCoordinate2D(latitude: 60.168992, longitude: 24.932366)
    // coordinate of the destination receieved from the home view (default: Kaivopuisto)
    var destination = CLLocationCoordinate2D(latitude: 60.15638994476689, longitude: 24.9572360295062)
    // place title for the destination annotation. It is also receieved from the home view.
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
        
        // execute GraphQL query with required variables
        data.fetchItinerary(originLat: Double(origin.latitude), originLon: Double(origin.longitude), destLat: Double(destination.latitude), destLon: Double(destination.longitude))
        
        makeRoute(mapView, origin, destination)
        makeAnnotation(mapView, origin, isOrigin: true, destTitle: destinationTitle)
        makeAnnotation(mapView, destination, isOrigin: false, destTitle: destinationTitle)
    }
    
    // MARK: - Functions for setting UI elements
    
    // make the button go back to the home view
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // make shadow under the button
    func makeShadow(){
        backBtn.layer.shadowColor = UIColor.black.cgColor
        backBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        backBtn.layer.shadowRadius = 0.8
        backBtn.layer.shadowOpacity = 0.5
    }
    
    // make the navigation bar transparent
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
        if (data.itineraries.count > 0) {
            return data.itineraries.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // represent each route options from GraphQL query results
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
        
        for (index,leg) in itinerary.legs.enumerated(){
            let modeName = leg.mode
            let modeImgName = setModeImgName(mode: modeName)
            generateImageView(imgName: modeImgName, superView: stackView, mode: modeName,size: 20)
            
            if let routeTrip = leg.trip {
                let routeShortName = routeTrip.routeShortName
                let routeshortNameLabel = UILabelPadding()
                routeshortNameLabel.text = routeShortName
                routeshortNameLabel.layer.borderColor = UIColor.darkGray.cgColor
                routeshortNameLabel.layer.borderWidth = 1
                routeshortNameLabel.layer.cornerRadius = 3
                routeshortNameLabel.font = routeshortNameLabel.font.withSize(13.0)
                stackView.addArrangedSubview(routeshortNameLabel)
            }
            
            if (index != itinerary.legs.count - 1) {
                generateImageView(imgName: "chevron.forward", superView: stackView, mode:"default",size: 20)
            }
        }
        
        let itineraryCell = tableView.dequeueReusableCell(withIdentifier: ItineraryTableCell.identifier, for: indexPath) as! ItineraryTableCell
        itineraryCell.configure(route:stackView, time: durationTime, duration: duration)
        
        return itineraryCell
    }
    
    // height for each cell and hide empty cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= data.itineraries.count {
            return 0
        }
        return tableView.rowHeight
    }
    
    // handle the selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indicates each route option
        if (data.itineraries.count > 0){
            let itinerary = data.itineraries[indexPath.row]
            selectedItinerary = itinerary
            
            // delete every polylines on the map
            self.mapView.removeOverlays(self.mapView.overlays)
            
            /* When a route is selected first, it is shown on the map.
             When the same route is selected again, the app will be moved to the detailed route view. */
            if (selectedRow == nil || selectedRow! != indexPath.row){
                selectedRow = indexPath.row
            } else if (indexPath.row == selectedRow!){
                performSegue(withIdentifier: "showDetail", sender: self)
            }
            generateRoute(self.mapView, legs: itinerary.legs)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? RouteDetailViewController{
            detailVC.origin = origin
            detailVC.destination = destination
            detailVC.itinerary = selectedItinerary
            detailVC.destinationTitle = destinationTitle
        }
    }
}
// MARK: - MKMapViewDelegate

extension RouteSuggestionsViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (overlay as? ModePolyline)?.color
        renderer.lineWidth = 5
        return renderer
    }
}

// MARK: - ItineraryManagerDelegate

// When the route options are loaded, 
extension RouteSuggestionsViewController:ItineraryManagerDelegate{
    func didUpdateData(_ itineraryManager: ItineraryManager, data: [Itineraries]) {
        self.tableView.reloadData()
        
        let firstIndexPath = IndexPath(row: 0, section: 0)
        //self.tableView(at: firstIndexPath, animated: false, scrollPosition: .none)
        self.tableView(self.tableView, didSelectRowAt: firstIndexPath)
    }
}
