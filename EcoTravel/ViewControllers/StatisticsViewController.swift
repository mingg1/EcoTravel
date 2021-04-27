//
//  StatisticsViewController.swift
//  EcoTravel
//
//  Created by iosdev on 15.4.2021.
//

import UIKit
import Charts
import MOPRIMTmdSdk

class StatisticsViewController: UIViewController, ChartViewDelegate {
    
    var pieChart = PieChartView()
    
    var walkingData = PieChartDataEntry(value: 0)
    var cyclingData = PieChartDataEntry(value: 0)
    var carData = PieChartDataEntry(value: 0)
    var transportData = PieChartDataEntry(value: 0)
    
    var numberOfDownloadDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        
        walkingData.value = 15
        walkingData.label = "Walking"
        
        cyclingData.value = 40
        cyclingData.label = "Cycling"
        
        carData.value = 20
        carData.label = "Car"
        
        transportData.value = 25
        transportData.label = "Public Transport"
        
        numberOfDownloadDataEntries = [walkingData, cyclingData, carData, transportData]
        
        fetchStats()
        fetchMovementData()
        // createSyntheticData()
    }
    
    func fetchStats() {
        TMDCloudApi.fetchStats(forLast: 30).continueOnSuccessWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
                if let error = task.error {
                    NSLog("fetchStats Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchStats result: %@", data)
                    
                    for trip in data.allStats() {
                        print("STATS: activity: \(trip.activity), userCo2: \(trip.userCo2), userDistance: \(trip.userDistance), userDuration: \(trip.userDuration), userLegs: \(trip.userLegs), communityCo2: \(trip.communityCo2), communityDistance: \(trip.communityDistance), communityDuration: \(trip.communityDuration), communityLegs: \(trip.communityLegs), communitySize: \(trip.communitySize), dateString: \(trip.dateString)")
                    }
                }
            }
        }
    }
    
    func fetchMovementData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let startTime = formatter.date(from: "2021/01/01 00:00")
        let startTimeMilliseconds = Int64((startTime!.timeIntervalSince1970 * 1000.0).rounded())
        let endTime = Date()
        let endTimeMilliseconds = Int64((endTime.timeIntervalSince1970 * 1000.0).rounded())
        
        TMDCloudApi.fetchData(withStart: startTimeMilliseconds, withEnd: endTimeMilliseconds).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
                if let error = task.error {
                    NSLog("fetchData Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchData result: %@", data)
                    
                    for trip in data {
                        let trip = trip as! TMDActivity
                        print("DATA: activityId: \(trip.activityId), timestampDownload: \(trip.timestampDownload), timestampStart: \(trip.timestampStart), timestampEnd: \(trip.timestampEnd), timestampUpdate: \(trip.timestampUpdate), correctedActivity: \(trip.correctedActivity), originalActivity: \(trip.originalActivity), co2: \(trip.co2), distance: \(trip.distance), speed: \(trip.speed), polyline: \(trip.polyline), origin: \(trip.origin), destination: \(trip.destination), metadata: \(trip.metadata), verifiedByUser: \(trip.verifiedByUser), syncedWithCloud: \(trip.syncedWithCloud)")
                    }
                }
            }
        }
    }
    
    func createSyntheticData() {
        let origin = CLLocation(latitude: 60.2238542, longitude: 24.7586268)
        let destination = CLLocation(latitude: 60.16, longitude: 24.93)
        let endTime = Int64((Date().timeIntervalSince1970 * 1000.0).rounded()) + 3600000
        
        TMDCloudApi.generateSyntheticData(withOriginLocation: origin, destination: destination, stopTimestamp: endTime, requestType: TMDSyntheticRequestType.car, hereApiKey: "CnnKj8CsVyqNIv0qtDG3NXMs5irPJgdi0RplONmORAQ")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pieChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        pieChart.center = view.center
        
        view.addSubview(pieChart)
        
        //      var entries = [walkingData, cyclingData, carData, transportData]
        
        
        /*   for item in 0...numberOfDownloadDataEntries.count-1 {
         numberOfDownloadDataEntries.append(PieChartDataEntry (value: Double(item)))
         }*/
        
        let set = PieChartDataSet(entries: numberOfDownloadDataEntries)
        set.colors = ChartColorTemplates.colorful()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        
    }
}
