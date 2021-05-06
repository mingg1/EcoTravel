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
    
    @IBOutlet weak var yearlyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var pieChartContainer: UIView!
    
    var fetchedResultsController: NSFetchedResultsController<StatisticCoreData>?
    var pieChart = PieChartView()
    var pieChartDataEntries = [PieChartDataEntry]()
    
    var unknownDistance = 0.0
    var walkRunDistance = 0.0
    var bicycleDistance = 0.0
    var otherNonMotorizedDistance = 0.0
    var carDistance = 0.0
    var otherMotorizedDistance = 0.0
    var publicTransportDistance = 0.0
    var planeDistance = 0.0
    var electricVehicleDistance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchAndStoreData = FetchAndStoreData()
        fetchAndStoreData.fetchUsersTrips()
        fetchAndStoreData.fetchStatistics()
        
        fetchStatisticsFromCoreData()
        setupPieChart()
        displayStatsForLastYear()
        yearlyButton.isSelected = true
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
    
    func displayDailyStat() {
        resetTotalDistances()
        
        guard let statistics = fetchedResultsController?.fetchedObjects else {
            fatalError("Statistics not found from fetched results controller")
        }
        
        //let dateToday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateToday = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateTodayString = formatter.string(from: dateToday)
        let dateTodayMidnightString = "\(dateTodayString) 00:00"
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateTodayMignight = formatter.date(from: dateTodayMidnightString)
        let dateTodayMignightInMilliseconds = Int((dateTodayMignight!.timeIntervalSince1970 * 1000.0).rounded())
        
        for statistic in statistics {
            guard let activityDateString = statistic.dateString else {
                fatalError("activity Date Error")
                
            }
            
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedActivityDate = formatter.date(from: activityDateString)
            
            let activityDateMilliseconds = Int((formattedActivityDate!.timeIntervalSince1970 * 1000.0).rounded())
            
            if(activityDateMilliseconds > dateTodayMignightInMilliseconds) {
                calculateTotalDistance(statistic: statistic)
            }
        }
        
        setPieChartDataEntries()
    }
    
    func displayStatForLastWeek() {
        resetTotalDistances()
        
        guard let statistics = fetchedResultsController?.fetchedObjects else {
            fatalError("Statistics not found from fetched results controller")
        }
        
        let dateWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let dateWeekAgoMilliseconds = Int((dateWeekAgo!.timeIntervalSince1970 * 1000.0).rounded())
        
        for statistic in statistics {
            guard let activityDateString = statistic.dateString else {
                fatalError("activity Date Error")
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedActivityDate = formatter.date(from: activityDateString)
            
            let activityDateMilliseconds = Int((formattedActivityDate!.timeIntervalSince1970 * 1000.0).rounded())
            
            if(activityDateMilliseconds > dateWeekAgoMilliseconds) {
                calculateTotalDistance(statistic: statistic)
            }
        }
        
        setPieChartDataEntries()
    }
    
    func displayStatForLastMonth() {
        resetTotalDistances()
        
        guard let statistics = fetchedResultsController?.fetchedObjects else {
            fatalError("Statistics not found from fetched results controller")
        }
        
        let dateMonthAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())
        let dateMonthAgoMilliseconds = Int((dateMonthAgo!.timeIntervalSince1970 * 1000.0).rounded())
        
        for statistic in statistics {
            guard let activityDateString = statistic.dateString else {
                fatalError("activity Date Error")
                
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedActivityDate = formatter.date(from: activityDateString)
            
            let activityDateMilliseconds = Int((formattedActivityDate!.timeIntervalSince1970 * 1000.0).rounded())
            
            if(activityDateMilliseconds > dateMonthAgoMilliseconds) {
                calculateTotalDistance(statistic: statistic)
            }
        }
        
        setPieChartDataEntries()
    }
    
    func displayStatsForLastYear() {
        resetTotalDistances()
        
        guard let statistics = fetchedResultsController?.fetchedObjects else {
            fatalError("Statistics not found from fetched results controller")
        }
        
        let dateYearAgo = Calendar.current.date(byAdding: .day, value: -365, to: Date())
        let dateYearAgoMilliseconds = Int((dateYearAgo!.timeIntervalSince1970 * 1000.0).rounded())
        
        for statistic in statistics {
            guard let activityDateString = statistic.dateString else {
                fatalError("activity Date Error")
                
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedActivityDate = formatter.date(from: activityDateString)
            
            let activityDateMilliseconds = Int((formattedActivityDate!.timeIntervalSince1970 * 1000.0).rounded())
            
            if(activityDateMilliseconds > dateYearAgoMilliseconds) {
                calculateTotalDistance(statistic: statistic)
            }
        }
        
        setPieChartDataEntries()
    }
    
    func resetTotalDistances() {
        unknownDistance = 0.0
        walkRunDistance = 0.0
        bicycleDistance = 0.0
        otherNonMotorizedDistance = 0.0
        carDistance = 0.0
        otherMotorizedDistance = 0.0
        publicTransportDistance = 0.0
        planeDistance = 0.0
        electricVehicleDistance = 0.0
    }
    
    func calculateTotalDistance(statistic: StatisticCoreData) {
        switch statistic.activity {
        case "unknown", "stationary":
            unknownDistance += statistic.userDistance
        case "non-motorized/pedestrian", "non-motorized/pedestrian/walk", "non-motorized/pedestrian/run":
            walkRunDistance += statistic.userDistance
        case "non-motorized/bicycle":
            bicycleDistance += statistic.userDistance
        case "non-motorized", "non-motorized/wheelchair", "non-motorized/snow/cross-country-skiing", "non-motorized/snow":
            otherNonMotorizedDistance += statistic.userDistance
        case "motorized/road/car":
            carDistance += statistic.userDistance
        case "motorized", "motorized/road", "motorized/road/motorbike", "motorized/road/scooter", "motorized/water/ferry", "motorized/water", "motorized/air":
            otherMotorizedDistance += statistic.userDistance
        case "motorized/road/bus", "motorized/rail", "motorized/rail/tram", "motorized/rail/train", "motorized/rail/metro":
            publicTransportDistance += statistic.userDistance
        case "motorized/air/plane":
            planeDistance += statistic.userDistance
        case "motorized/road/kickscooter/electric", "motorized/road/bicycle/electric", "motorized/road/car/electric":
            electricVehicleDistance += statistic.userDistance
        default:
            print("Statistic activity name unknown")
        }
    }
    
    func setPieChartDataEntries() {
        let unknownData = PieChartDataEntry(value: Double(round(1000 * unknownDistance) / 1000) / 1000, label: "Unknown")
        let walkRunData = PieChartDataEntry(value: Double(round(1000 * walkRunDistance) / 1000) / 1000, label: "Walk/run")
        let bicycleData = PieChartDataEntry(value: Double(round(1000 * bicycleDistance) / 1000) / 1000, label: "Bicycle")
        let otherNonMotorizedData = PieChartDataEntry(value: Double(round(1000 * otherNonMotorizedDistance) / 1000) / 1000, label: "Other non-motorized")
        let carData = PieChartDataEntry(value: Double(round(1000 * carDistance) / 1000) / 1000, label: "Car")
        let otherMotorizedData = PieChartDataEntry(value: Double(round(1000 * otherMotorizedDistance) / 1000) / 1000, label: "Other motorized")
        let publicTransportData = PieChartDataEntry(value: Double(round(1000 * publicTransportDistance) / 1000) / 1000, label: "Public transport")
        let planeData = PieChartDataEntry(value: Double(round(1000 * planeDistance) / 1000) / 1000, label: "Plane")
        let electricVehicleData = PieChartDataEntry(value: Double(round(1000 * electricVehicleDistance) / 1000) / 1000, label: "Electric vehicle")
        
        pieChartDataEntries = [unknownData, walkRunData, bicycleData, otherNonMotorizedData, carData, otherMotorizedData, publicTransportData, planeData, electricVehicleData]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        displayStatsForLastYear()
        setPieChartData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        renderPieChart()
        setPieChartData()
    }
    
    func renderPieChart() {
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250)
        //pieChart.frame = CGRect(x: 0, y: 0, width: pieChartContainer.frame.size.width, height: 250)
        //pieChart.center = view.center
        pieChartContainer.addSubview(pieChart)
        //view.addSubview(pieChart)
    }
    
    func setPieChartData() {
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: "")
        dataSet.colors = [UIColor.gray, UIColor.green, UIColor.orange, UIColor.yellow, UIColor.systemTeal, UIColor.blue, UIColor.red, UIColor.systemIndigo, UIColor.cyan]
        
        dataSet.entryLabelColor = UIColor.black
        dataSet.xValuePosition = .outsideSlice
        dataSet.yValuePosition = .insideSlice
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
    }
    
    @IBAction func weeklyButtonTapped(_ sender: UIButton) {
        displayStatForLastWeek()
        setPieChartData()
        weeklyButton.isSelected = true
        yearlyButton.isSelected = false
        monthlyButton.isSelected = false
        dailyButton.isSelected = false
    }
    
    @IBAction func dailyButtonTapped(_ sender: UIButton) {
        displayDailyStat()
        setPieChartData()
        dailyButton.isSelected = true
        yearlyButton.isSelected = false
        monthlyButton.isSelected = false
        weeklyButton.isSelected = false
        
    }
    
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        displayStatForLastMonth()
        setPieChartData()
        monthlyButton.isSelected = true
        yearlyButton.isSelected = false
        weeklyButton.isSelected = false
        dailyButton.isSelected = false
    }
    
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        displayStatsForLastYear()
        setPieChartData()
        yearlyButton.isSelected = true
        monthlyButton.isSelected = false
        weeklyButton.isSelected = false
        dailyButton.isSelected = false
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
