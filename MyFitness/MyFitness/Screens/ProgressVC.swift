//
//  ProgressVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import SwiftChart

class ProgressVC: UIViewController {
    
    var weightLog = [Int]()
    let chartView = Chart(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureChartView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeightLog), name: .weightLogChanged, object: nil)
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addButtonTapped() {
        presentAlert()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Add Weight", message: "Enter your weight to track your progress.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your calories here"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let textFieldEntry = alertController.textFields![0].text
            guard let integerEntry = Int(textFieldEntry!) else {
                print("error")
                return
            }
            self.weightLog.append(integerEntry)
            NotificationCenter.default.post(name: .weightLogChanged, object: nil)
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func updateWeightLog() {
        plotChartView()
    }
    
    func plotChartView() {
        var weightCountSeries = [Double]()
        
        for log in weightLog {
            weightCountSeries.append(Double(log))
        }
        
        let series = ChartSeries(weightCountSeries)
        
        series.color = ChartColors.blueColor()
        series.area = true
        chartView.add(series)
    }
    
    func configureChartView() {
        let padding: CGFloat = 20
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            chartView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3)
        ])
    }
    
}
