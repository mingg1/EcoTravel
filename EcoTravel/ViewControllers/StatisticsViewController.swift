//
//  StatisticsViewController.swift
//  EcoTravel
//
//  Created by iosdev on 15.4.2021.
//

import UIKit
import Charts
import MOPRIMTmdSdk
import CoreData

class StatisticsViewController: UIViewController, ChartViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    var fetchedResultsController: NSFetchedResultsController<StatisticCoreData>?
    var pieChart = PieChartView()
    var pieChartDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchAndStoreData = FetchAndStoreData()
        fetchAndStoreData.fetchUsersTrips()
        fetchAndStoreData.fetchStatistics()
        
        fetchStatisticsFromCoreData()
        setupPieChart()
        calculateAndSetPieChartStatistics()
        
        // createSyntheticData()
    }
    
    func setupPieChart() {
        pieChart.chartDescription?.enabled = false
        pieChart.drawHoleEnabled = false
        pieChart.rotationAngle = 0
        pieChart.rotationEnabled = true
        let l = pieChart.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.xEntrySpace = 10
        l.yEntrySpace = 0
        self.pieChart.drawHoleEnabled = false
        self.pieChart.drawEntryLabelsEnabled = true
        self.pieChart.notifyDataSetChanged()
    }
    
    func fetchStatisticsFromCoreData() {
        let statisticsRequest: NSFetchRequest<StatisticCoreData> = StatisticCoreData.fetchRequest()
        statisticsRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: statisticsRequest, managedObjectContext: AppDelegate.viewContext, sectionNameKeyPath: "activity", cacheName: "statisticsCache")
        
        fetchedResultsController!.delegate = self as NSFetchedResultsControllerDelegate
        try? fetchedResultsController?.performFetch()
    }
    
    func calculateAndSetPieChartStatistics() {
        guard let statistics = fetchedResultsController?.fetchedObjects else {
            fatalError("Statistics not found from fetched results controller")
        }
        
        var unknownDistance = 0.3
        var stationaryDistance = 0.0
        var nonMotorizedDistance = 4.0
        var bicycleDistance = 0.0
        var pedestrianDistance = 0.0
        var walkDistance = 6.0
        var runDistance = 0.0
        var motorizedDistance = 0.0
        var motorizedRoadDistance = 0.0
        var carDistance = 7.0
        var busDistance = 0.0
        var railDistance = 0.0
        var tramDistance = 0.0
        var trainDistance = 10.0
        var metroDistance = 0.0
        var planeDistance = 0.0
        var wheelChairDistance = 0.0
        var skiingDistance = 3.0
        var EScooterDistance = 0.0
        var EbikeDistance = 0.0
        var carElectricDistance = 9.0
        var motorbikeDistance = 0.0
        var scooterDistance = 0.0
        var ferryDistance = 0.0
        var snowDistance = 0.0
        var waterDistance = 0.0
        var airDistance = 0.0
        
        
        for statistic in statistics {
            switch statistic.activity {
            case "unknown":
                unknownDistance += statistic.userDistance
            case "stationary":
                stationaryDistance += statistic.userDistance
            case "non-motorized":
                nonMotorizedDistance += statistic.userDistance
            case "non-motorized/bicycle":
                bicycleDistance += statistic.userDistance
            case "non-motorized/pedestrian":
                pedestrianDistance += statistic.userDistance
            case "non-motorized/pedestrian/walk":
                walkDistance += statistic.userDistance
            case "non-motorized/pedestrian/run":
                runDistance += statistic.userDistance
            case "motorized":
                motorizedDistance += statistic.userDistance
            case "motorized/road":
                motorizedRoadDistance += statistic.userDistance
            case "motorized/road/car":
                carDistance += statistic.userDistance
            case "motorized/road/bus":
                busDistance += statistic.userDistance
            case "motorized/rail":
                railDistance += statistic.userDistance
            case "motorized/rail/tram":
                tramDistance += statistic.userDistance
            case "motorized/rail/train":
                trainDistance += statistic.userDistance
            case "motorized/rail/metro":
                metroDistance += statistic.userDistance
            case "motorized/air/plane":
                planeDistance += statistic.userDistance
            case "non-motorized/wheelchair":
                wheelChairDistance += statistic.userDistance
            case "non-motorized/snow/cross-country-skiing":
                skiingDistance += statistic.userDistance
            case "motorized/road/kickscooter/electric":
                EScooterDistance += statistic.userDistance
            case "motorized/road/bicycle/electric":
                EbikeDistance += statistic.userDistance
            case "motorized/road/car/electric":
                carElectricDistance += statistic.userDistance
            case "motorized/road/motorbike":
                motorbikeDistance += statistic.userDistance
            case "motorized/road/scooter":
                scooterDistance += statistic.userDistance
            case "motorized/water/ferry":
                ferryDistance += statistic.userDistance
            case "non-motorized/snow":
                snowDistance += statistic.userDistance
            case "motorized/water":
                waterDistance += statistic.userDistance
            case "motorized/air":
                airDistance += statistic.userDistance
            default:
                print("Statistic activity name unknown")
            }
        }
        
        
        
        let unknownData = PieChartDataEntry(value: Double(round(1000 * unknownDistance) / 1000), label: "Unknown")
        
        let nonMotorizedData = PieChartDataEntry(value: Double(round(1000 * (nonMotorizedDistance + stationaryDistance + wheelChairDistance + skiingDistance + snowDistance)) / 1000), label: "Non-Motor")
        let bicycleData = PieChartDataEntry(value: Double(round(1000 * bicycleDistance) / 1000), label: "Bicycle")
        let pedestrianData = PieChartDataEntry(value: Double(round(1000 * (pedestrianDistance + walkDistance + runDistance)) / 1000), label: "Walking")
        let motorizedData = PieChartDataEntry(value: Double(round(1000 * (motorizedDistance + motorizedRoadDistance + ferryDistance + waterDistance + airDistance + motorbikeDistance) / 1000)), label: "Motorized")
        let carData = PieChartDataEntry(value: Double(round(1000 * carDistance) / 1000), label: "Car")
        
        let transportData = PieChartDataEntry(value: Double(round(1000 * (busDistance + railDistance + tramDistance + trainDistance + metroDistance + planeDistance)) / 1000), label: "Public Transport")
        let planeData = PieChartDataEntry(value: Double(round(1000 * planeDistance) / 1000), label: "Plane")
        let ElectricData = PieChartDataEntry(value: Double(round(1000 * (EScooterDistance + carElectricDistance + EbikeDistance)) / 1000), label: "Electric")
        
        
        pieChartDataEntries = [unknownData, nonMotorizedData, bicycleData, pedestrianData, motorizedData, carData, transportData, planeData, ElectricData,  ]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        calculateAndSetPieChartStatistics()
        setPieChartData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        renderPieChart()
        setPieChartData()
    }
    
    func renderPieChart() {
        
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250)
        pieChart.center = view.center
        view.addSubview(pieChart)
    }
    
    func setPieChartData() {
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: "")
        dataSet.colors = [UIColor.blue, UIColor.green, UIColor.gray, UIColor.brown, UIColor.magenta, UIColor.purple, UIColor.red, UIColor.systemPink, UIColor.cyan]
        
        // dataSet.drawValuesEnabled = false
        dataSet.entryLabelColor = UIColor.black
        dataSet.xValuePosition = .outsideSlice
        dataSet.yValuePosition = .insideSlice
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
    }
    
    func createSyntheticData() {
        // Karaportti, Espoo
        let origin = CLLocation(latitude: 60.2238542, longitude: 24.7586268)
        // Leppävaara, Espoo
        // let destination = CLLocation(latitude: 60.2166658, longitude: 24.8166634)
        // Helsinki
        let destination = CLLocation(latitude: 60.16, longitude: 24.93)
        let endTime = Int64((Date().timeIntervalSince1970 * 1000.0).rounded()) + 3600000
        
        TMDCloudApi.generateSyntheticData(withOriginLocation: origin, destination: destination, stopTimestamp: endTime, requestType: TMDSyntheticRequestType.bicycle, hereApiKey: "CnnKj8CsVyqNIv0qtDG3NXMs5irPJgdi0RplONmORAQ")
    }
    
}
