//
//  AddWorkoutVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/27/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import CoreData

protocol AddWorkoutDelegate {
    func workoutAdded()
}

class AddWorkoutVC: UIViewController {
    
    let tableView = UITableView()
    let workoutNameTextField = MFTextField()
    let notesTextView = MFTextView(frame: .zero)
    let saveButton = UIButton()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedExerciseRC: NSFetchedResultsController<Exercise>?
    
    var workout: Workout?
    var delegate: AddWorkoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureWorkoutName()
        configureNotesTextView()
        configureTableView()
        configureSaveButton()
        createDismissKeyboardTapGesture()
        configureWorkoutDetails()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Add Workout Details"
        navigationItem.largeTitleDisplayMode = .never
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
        
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeBarButton
    }
    
    @objc func addButtonTapped() {
        let addExerciseVC = AddExerciseVC()
        addExerciseVC.workout = workout
        addExerciseVC.delegate = self
        
        addExerciseVC.modalPresentationStyle = .automatic
        present(addExerciseVC, animated: true, completion: nil)
    }
    
    @objc func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func refresh() {
        // check if there's a place set
        guard let workout = workout else { return }
        
        // get a fetch request for the places
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "workout = %@", workout)
        
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            // assign the fetched results controller
            fetchedExerciseRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            // execute the fetch
            try fetchedExerciseRC!.performFetch()
        } catch {
            print("Error fetching notes")
        }
        
        // refresh the table view
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func configureWorkoutDetails() {
        guard let workout = workout else { return }
        notesTextView.text = workout.notes
        workoutNameTextField.text = workout.name
    }
    
    private func configureWorkoutName() {
        workoutNameTextField.placeholder = "workout name"
    }
    
    private func configureNotesTextView() {
        notesTextView.isEditable = true
        notesTextView.isSelectable = true
        notesTextView.isScrollEnabled = true
        notesTextView.text = "workout notes"
        
        notesTextView.delegate = self
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: view.bounds.height / 3, width: view.bounds.width, height: view.bounds.height / 2)
        tableView.rowHeight = 120
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: WorkoutCell.reuseID)
    }
    
    func configureSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func layoutUI() {
        view.addSubviews(workoutNameTextField, notesTextView, tableView, saveButton)
        
        NSLayoutConstraint.activate([
            workoutNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            workoutNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            workoutNameTextField.heightAnchor.constraint(equalToConstant: 30),
            
            notesTextView.topAnchor.constraint(equalTo: workoutNameTextField.bottomAnchor, constant: 8),
            notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notesTextView.heightAnchor.constraint(equalToConstant: 80),
            
            tableView.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            
            saveButton.heightAnchor.constraint(equalToConstant: 80),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    @objc func saveTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
        
        if workout == nil {
            self.workout = Workout(context: context)
            
            workout!.date = Date()
            workout!.name = workoutNameTextField.text
            workout!.notes = notesTextView.text
            
        } else {
            workout?.date = Date()
            workout?.name = workoutNameTextField.text
            workout?.notes = notesTextView.text
        }
        
        appDelegate.saveContext()
        
        delegate?.workoutAdded()
        
        dismiss(animated: true, completion: nil)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}

extension AddWorkoutVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedExerciseRC?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutCell.reuseID) as? WorkoutCell else { return UITableViewCell() }
        guard let exercise = fetchedExerciseRC?.object(at: indexPath) else { return UITableViewCell() }
        
        cell.set(exercise: exercise)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exercise = self.fetchedExerciseRC?.object(at: indexPath) else { return }
        
        let addExerciseVC = AddExerciseVC()
        
        addExerciseVC.workout = workout
        addExerciseVC.exercise = exercise
        addExerciseVC.delegate = self
        
        addExerciseVC.modalPresentationStyle = .automatic
        
        present(addExerciseVC, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    #warning("add editing to delete rows")
    
}

extension AddWorkoutVC: AddExerciseDelegate {
    
    func exerciseAdded() {
        refresh()
    }
    
}

extension AddWorkoutVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.text == "workout notes" {
            notesTextView.text = ""
        }
    }
}
