//
//  AddWorkoutVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/27/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

protocol AddWorkoutVCDelegate: class {
    func updateWorkout()
}

class AddWorkoutVC: UIViewController {
    
    let tableView = UITableView()
    let workoutTypeLabel = MFTitleLabel(textAlignment: .left, fontSize: 20)
    let workoutTypePickerView = UIPickerView()
    let notesTextView = MFTextView(frame: .zero)
    let saveButton = UIButton()
    
    var workout: Workout? {
        didSet {
            configureWorkoutDetails()
        }
    }
    
    var delegate: AddWorkoutVCDelegate?
    
    var exercises = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureWorkoutTypeLabel()
        configureWorkoutType()
        configureNotesTextView()
        configureTableView()
        configureSaveButton()
        createDismissKeyboardTapGesture()
        guard let workoutTypeValue = workout?.workoutType.rawValue else {
            workoutTypePickerView.selectRow(0, inComponent: 0, animated: true)
            return
        }
        workoutTypePickerView.selectRow(workoutTypeValue, inComponent: 0, animated: true)
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
        presentAlert()
    }
    
    @objc func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func configureWorkoutDetails() {
        guard let workout = workout else { return }
        notesTextView.text = workout.notes
        exercises = workout.exercises
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Add Exercise", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter the exercise name here"
            textField.keyboardType = .default
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter the weight you lifted here"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter the number of reps here"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let exerciseNameText = alertController.textFields![0].text!
            let exerciseWeightText = alertController.textFields![1].text!
            let exerciseRepsText = alertController.textFields![2].text!
            
            guard !exerciseNameText.isEmpty,
                let exerciseWeightAsDouble = Double(exerciseWeightText),
                let exerciseRepsAsInt = Int(exerciseRepsText) else {
                print("Error")
                return
            }
            
            self.exercises.append(Exercise(name: exerciseNameText, reps: exerciseRepsAsInt, weight: exerciseWeightAsDouble))
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func configureWorkoutTypeLabel() {
        view.addSubview(workoutTypeLabel)
        workoutTypeLabel.text = "WORKOUT TYPE"
        
        NSLayoutConstraint.activate([
            workoutTypeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            workoutTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            workoutTypeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureWorkoutType() {
        view.addSubview(workoutTypePickerView)
        workoutTypePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.workoutTypePickerView.delegate = self
        self.workoutTypePickerView.dataSource = self
        
        NSLayoutConstraint.activate([
            workoutTypePickerView.topAnchor.constraint(equalTo: workoutTypeLabel.bottomAnchor, constant: 8),
            workoutTypePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutTypePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            workoutTypePickerView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureNotesTextView() {
        view.addSubview(notesTextView)
        
        notesTextView.isEditable = true
        notesTextView.isSelectable = true
        notesTextView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            notesTextView.topAnchor.constraint(equalTo: workoutTypePickerView.bottomAnchor, constant: 8),
            notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notesTextView.heightAnchor.constraint(equalToConstant: 70)
        ])
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
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func saveTapped() {
        let selectedWorkoutType = WorkoutType.allCases[workoutTypePickerView.selectedRow(inComponent: 0)]
        let workout = Workout(workoutType: selectedWorkoutType, exercises: exercises, notes: notesTextView.text)
        
        PersistenceManager.updateWith(workout: workout, actionType: .add) { (error) in
            guard let error = error else {
                print("Successfully added workout")
                return
            }
            
            print("Error: \(error)")
        }
        
        delegate?.updateWorkout()
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}

extension AddWorkoutVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutCell.reuseID) as? WorkoutCell else { return UITableViewCell() }
        
        let exercise = exercises[indexPath.row]
        cell.set(exercise: exercise)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension AddWorkoutVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return WorkoutType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return WorkoutType.allCases[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        workout?.workoutType = WorkoutType.allCases[workoutTypePickerView.selectedRow(inComponent: component)]
    }
    
}
