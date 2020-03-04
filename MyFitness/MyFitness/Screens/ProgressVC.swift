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
    
    let lineChartView = LineChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        customizeChart(dataPoints: ["Jan", "Feb", "Mar", "Apr", "May"], values: [0,1,2,3,4])
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
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
    
    func layoutUIElements() {
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineChartView)
        
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lineChartView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
}
