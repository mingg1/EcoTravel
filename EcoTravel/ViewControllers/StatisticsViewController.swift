//
//  StatisticsViewController.swift
//  EcoTravel
//
//  Created by iosdev on 15.4.2021.
//

import UIKit
import Charts

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
