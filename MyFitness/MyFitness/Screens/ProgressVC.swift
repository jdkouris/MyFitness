//
//  ProgressVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ProgressVC: UIViewController {
    
    // MARK: - Properties and Variables
    
    let chartView = Chart(frame: .zero)
    let tableView = UITableView()
    let padding: CGFloat = 20
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedWeightsRC: NSFetchedResultsController<Weight>?

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureChartView()
        configureTableView()
        layoutUIElements()
        
        getWeights()
        plotChartView()
    }
    
    func getWeights() {
        do {
            let request = Weight.fetchRequest() as NSFetchRequest<Weight>
            
            let dateSort = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [dateSort]
            
            fetchedWeightsRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedWeightsRC?.performFetch()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching weights")
        }
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Add Weight", message: "Enter your weight to track your progress.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your weight here"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let textFieldEntry = alertController.textFields![0].text
            guard let entryAsDouble = Double(textFieldEntry!) else {
                print("error")
                return
            }
            
            let weight = Weight(context: self.context)
            weight.date = Date()
            weight.value = entryAsDouble
            
            self.appDelegate.saveContext()
            self.getWeights()
            self.plotChartView()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func plotChartView() {
        chartView.clearsContextBeforeDrawing = true
        var weightCountSeries = [Double]()
        guard let fetchedWeights = fetchedWeightsRC?.fetchedObjects else { return }
        
        for log in fetchedWeights {
            weightCountSeries.append(Double(log.value))
        }
        
        let series = ChartSeries(weightCountSeries)
        
        series.color = ChartColors.blueColor()
        series.area = false
        chartView.add(series)
    }
    
    // MARK: - Configuration
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addButtonTapped() {
        presentAlert()
    }
    
    func configureChartView() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.hideHighlightLineOnTouchEnd = true
        chartView.showXLabelsAndGrid = false
        chartView.isHighlighted = false
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

// MARK: - Extension: Table Delegate and Data Source

extension ProgressVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedWeightsRC?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeightCell.reuseID) as? WeightCell else { return UITableViewCell() }
        
        guard let weight = fetchedWeightsRC?.object(at: indexPath) else { return UITableViewCell() }
        cell.set(weight: weight)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
