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
        calculateAndSetPieChartStatistics()
        
        // createSyntheticData()
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
        
        var unknownDistance = 0.0
        var unknownDuration = 0.0
        var stationaryDistance = 0.0
        var stationaryDuration = 0.0
        var nonMotorizedDistance = 0.0
        var nonMotorizedDuration = 0.0
        var bicycleDistance = 0.0
        var bicycleDuration = 0.0
        var pedestrianDistance = 0.0
        var pedestrianDuration = 0.0
        var walkDistance = 0.0
        var walkDuration = 0.0
        var runDistance = 0.0
        var runDuration = 0.0
        var motorizedDistance = 0.0
        var motorizedDuration = 0.0
        var motorizedRoadDistance = 0.0
        var motorizedRoadDuration = 0.0
        var carDistance = 0.0
        var carDuration = 0.0
        var busDistance = 0.0
        var busDuration = 0.0
        var railDistance = 0.0
        var railDuration = 0.0
        var tramDistance = 0.0
        var tramDuration = 0.0
        var trainDistance = 0.0
        var trainDuration = 0.0
        var metroDistance = 0.0
        var metroDuration = 0.0
        var planeDistance = 0.0
        var planeDuration = 0.0
        
        for statistic in statistics {
            switch statistic.activity {
            case "unknown":
                unknownDistance += statistic.userDistance
                unknownDuration += statistic.userDuration
            case "stationary":
                stationaryDistance += statistic.userDistance
                stationaryDuration += statistic.userDuration
            case "non-motorized":
                nonMotorizedDistance += statistic.userDistance
                nonMotorizedDuration += statistic.userDuration
            case "non-motorized/bicycle":
                bicycleDistance += statistic.userDistance
                bicycleDuration += statistic.userDuration
            case "non-motorized/pedestrian":
                pedestrianDistance += statistic.userDistance
                pedestrianDuration += statistic.userDuration
            case "non-motorized/pedestrian/walk":
                walkDistance += statistic.userDistance
                walkDuration += statistic.userDuration
            case "non-motorized/pedestrian/run":
                runDistance += statistic.userDistance
                runDuration += statistic.userDuration
            case "motorized":
                motorizedDistance += statistic.userDistance
                motorizedDuration += statistic.userDuration
            case "motorized/road":
                motorizedRoadDistance += statistic.userDistance
                motorizedRoadDuration += statistic.userDuration
            case "motorized/road/car":
                carDistance += statistic.userDistance
                carDuration += statistic.userDuration
            case "motorized/road/bus":
                busDistance += statistic.userDistance
                busDuration += statistic.userDuration
            case "motorized/rail":
                railDistance += statistic.userDistance
                railDuration += statistic.userDuration
            case "motorized/rail/tram":
                tramDistance += statistic.userDistance
                tramDuration += statistic.userDuration
            case "motorized/rail/train":
                trainDistance += statistic.userDistance
                trainDuration += statistic.userDuration
            case "motorized/rail/metro":
                metroDistance += statistic.userDistance
                metroDuration += statistic.userDuration
            case "motorized/air/plane":
                planeDistance += statistic.userDistance
                planeDuration += statistic.userDuration
            default:
                print("Statistic activity name unknown")
            }
        }
        
        let unknownData = PieChartDataEntry(value: Double(round(1000 * unknownDistance) / 1000), label: "Unknown")
        let stationaryData = PieChartDataEntry(value: Double(round(1000 * stationaryDistance) / 1000), label: "Stationary")
        let nonMotorizedData = PieChartDataEntry(value: Double(round(1000 * nonMotorizedDistance) / 1000), label: "Non-motorized")
        let bicycleData = PieChartDataEntry(value: Double(round(1000 * bicycleDistance) / 1000), label: "Bicycle")
        let pedestrianData = PieChartDataEntry(value: Double(round(1000 * pedestrianDistance) / 1000), label: "Pedestrian")
        let walkData = PieChartDataEntry(value: Double(round(1000 * walkDistance) / 1000), label: "Walk")
        let runData = PieChartDataEntry(value: Double(round(1000 * runDistance) / 1000), label: "Run")
        let motorizedData = PieChartDataEntry(value: Double(round(1000 * motorizedDistance) / 1000), label: "Motorized")
        let motorizedRoadData = PieChartDataEntry(value: Double(round(1000 * motorizedRoadDistance) / 1000), label: "Motorized/road")
        let carData = PieChartDataEntry(value: Double(round(1000 * carDistance) / 1000), label: "Car")
        let busData = PieChartDataEntry(value: Double(round(1000 * busDistance) / 1000), label: "Bus")
        let railData = PieChartDataEntry(value: Double(round(1000 * railDistance) / 1000), label: "Rail")
        let tramData = PieChartDataEntry(value: Double(round(1000 * tramDistance) / 1000), label: "Tram")
        let trainData = PieChartDataEntry(value: Double(round(1000 * trainDistance) / 1000), label: "Train")
        let metroData = PieChartDataEntry(value: Double(round(1000 * metroDistance) / 1000), label: "Metro")
        let planeData = PieChartDataEntry(value: Double(round(1000 * planeDistance) / 1000), label: "Plane")
        
        pieChartDataEntries = [unknownData, stationaryData, nonMotorizedData, bicycleData, pedestrianData, walkData, runData, motorizedData, motorizedRoadData, carData, busData, railData, tramData, trainData, metroData, planeData]
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
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
    }
    
    func setPieChartData() {
        let set = PieChartDataSet(entries: pieChartDataEntries)
        set.colors = ChartColorTemplates.colorful()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
    
    func createSyntheticData() {
        // Karaportti, Espoo
        let origin = CLLocation(latitude: 60.2238542, longitude: 24.7586268)
        // Leppävaara, Espoo
        let destination = CLLocation(latitude: 60.2166658, longitude: 24.8166634)
        // Helsinki
        // let destination = CLLocation(latitude: 60.16, longitude: 24.93)
        let endTime = Int64((Date().timeIntervalSince1970 * 1000.0).rounded()) + 3600000
        
        TMDCloudApi.generateSyntheticData(withOriginLocation: origin, destination: destination, stopTimestamp: endTime, requestType: TMDSyntheticRequestType.bicycle, hereApiKey: "CnnKj8CsVyqNIv0qtDG3NXMs5irPJgdi0RplONmORAQ")
    }
}
