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
    
    // MARK: - Variables and Properties
    
    let tableView = UITableView()
    var workouts = [Workout]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedWorkoutsRC: NSFetchedResultsController<Workout>?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWorkouts()
    }
    
    // MARK: - Configuration Methods
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.estimatedRowHeight = 200
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .systemBackground
        tableView.register(JournalCell.self, forCellReuseIdentifier: JournalCell.reuseID)
    }
    
    // MARK: - Data Method
    
    func getWorkouts() {
        do {
            let request: NSFetchRequest<Workout> = Workout.fetchRequest()
            
            let dateSort = NSSortDescriptor(key: "date", ascending: false)
            let nameSort = NSSortDescriptor(key: "name", ascending: false)
            request.sortDescriptors = [dateSort, nameSort]
            
            fetchedWorkoutsRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedWorkoutsRC!.performFetch()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching workouts")
        }
        
    }
    
    // MARK: - Button Actions
    
    @objc func addButtonTapped() {
        let destinationVC = AddWorkoutVC()
        destinationVC.delegate = self
        
        let workout = Workout(context: context)
        destinationVC.workout = workout
        
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true, completion: nil)
    }

}

// MARK: - Extensions

extension WorkoutJournalVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedWorkoutsRC?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JournalCell.reuseID, for: indexPath) as? JournalCell else { return UITableViewCell() }
        
        guard let workout = fetchedWorkoutsRC?.object(at: indexPath) else { return UITableViewCell() }
        cell.set(workout: workout)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workout = fetchedWorkoutsRC?.object(at: indexPath) else { return }
        
        let addWorkoutVC = AddWorkoutVC()
        addWorkoutVC.delegate = self
        addWorkoutVC.workout = workout
        addWorkoutVC.workoutNameTextField.text = workout.name
        addWorkoutVC.notesTextView.text = workout.notes
        
        let navController = UINavigationController(rootViewController: addWorkoutVC)
        navController.modalPresentationStyle = .automatic
        
        present(navController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let workout = fetchedWorkoutsRC?.object(at: indexPath) else { return }
            self.context.delete(workout)
            self.appDelegate.saveContext()
            self.getWorkouts()
        }
    }
    
}

extension WorkoutJournalVC: AddWorkoutDelegate {
    
    func workoutAdded() {
        getWorkouts()
    }
    
}
