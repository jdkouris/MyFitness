//
//  WorkoutJournalVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import CoreData

class WorkoutJournalVC: UIViewController {
    
    let tableView = UITableView()
    var workouts = [Workout]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedWorkoutsRC: NSFetchedResultsController<Workout>?
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWorkouts()
    }
    
    func getWorkouts() {
        do {
            workouts = try context.fetch(Workout.fetchRequest())
        } catch {
            print("Error retrieving workouts from CD")
        }
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 200
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .systemBackground
        tableView.register(JournalCell.self, forCellReuseIdentifier: JournalCell.reuseID)
    }
    
    @objc func addButtonTapped() {
        let destinationVC = AddWorkoutVC()
        
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true, completion: nil)
    }

}

extension WorkoutJournalVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JournalCell.reuseID, for: indexPath) as? JournalCell else { return UITableViewCell() }
        
        let workout = workouts[indexPath.row]
        cell.set(workout: workout)
        
        return cell
    }
    
}
