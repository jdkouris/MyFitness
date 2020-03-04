//
//  ProgressVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import Charts

class ProgressVC: UIViewController {
    
    let barChartView = BarChartView()
    let months = ["January", "February", "March", "April", "May", "June"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        customizeChart(dataPoints: months, values: [195.0,202.0,200.0,205.0,199.0,200.0].map { Double($0) })
        layoutUIElements()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addButtonTapped() {
        
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart View")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
//        barChartView.animate(yAxisDuration: 1.0)
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChartView.fitBars = true
    }
    
    func layoutUIElements() {
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barChartView)
        
        NSLayoutConstraint.activate([
            barChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            barChartView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
}
