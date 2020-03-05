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
    
    var weightLog = [Double]()
    let chartView = Chart(frame: .zero)
    let tableView = UITableView()
    let padding: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureChartView()
        configureTableView()
        layoutUIElements()
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
            textField.placeholder = "Enter your weight here"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let textFieldEntry = alertController.textFields![0].text
            guard let entryAsDouble = Double(textFieldEntry!) else {
                print("error")
                return
            }
            
            self.weightLog.append(entryAsDouble)
            NotificationCenter.default.post(name: .weightLogChanged, object: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func updateWeightLog() {
        plotChartView()
        tableView.reloadData()
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
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WeightCell.self, forCellReuseIdentifier: WeightCell.reuseID)
    }
    
    private func layoutUIElements() {
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            chartView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),
            
            tableView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension ProgressVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weightLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeightCell.reuseID) as? WeightCell else { return UITableViewCell() }
        
        let weight = weightLog[indexPath.row]
        cell.set(weight: weight)
        
        return cell
    }
}
