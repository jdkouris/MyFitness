//
//  CategoryExercisesVC.swift
//  MyFitness
//
//  Created by John Kouris on 11/25/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class CategoryExercisesVC: UIViewController {
    
    // MARK: - Variables and Properties
    
    var category: ExerciseCategory?
    var exercises: [DemoExercise] = []
    
    let tableView = UITableView()
    
    var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configureTableView()
        getExercises(for: category!)
    }
    
    // MARK: - Configuration Methods

    private func configureVC() {
        view.backgroundColor = .systemBackground
        
        if let name = category?.name {
            title = "Exercises for \(name)"
        } else {
            title = "Exercises"
        }
        
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeBarButton
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .systemBackground
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: ExerciseCell.reuseID)
        showActivityIndicator()
    }
    
    // MARK: - Data Methods
    
    func getExercises(for category: ExerciseCategory) {
        NetworkManager.shared.getExercises(for: category) { [weak self] result in
            guard let self = self else { return }
            self.hideActivityIndicator()
            
            switch result {
            case .success(let exercises):
                let filteredExercises = exercises.results.filter { (exercise) -> Bool in
                    let trimmedExercise = exercise.description.trimmingCharacters(in: .whitespaces)
                    return trimmedExercise.description.count >= 30
                }
                
                self.exercises.append(contentsOf: filteredExercises)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                self.presentMFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Dismiss")
            }
        }
    }
    
    // MARK: - Button Actions
    
    @objc func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Activity Indicator Methods
    
    private func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        tableView.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    
    private func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.stopAnimating()
        }
    }

}

// MARK: - Extensions

extension CategoryExercisesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCell.reuseID, for: indexPath) as? ExerciseCell else { return UITableViewCell() }
        
        let exercise = exercises[indexPath.row]
        cell.set(exercise: exercise)
        
        return cell
    }
    
}
