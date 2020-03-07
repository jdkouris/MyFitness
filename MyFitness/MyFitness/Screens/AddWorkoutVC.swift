//
//  AddWorkoutVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/27/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class AddWorkoutVC: UIViewController {
    
    let tableView = UITableView()
    let workoutTypeLabel = MFTitleLabel(textAlignment: .left, fontSize: 24)
    let workoutTypePickerView = UIPickerView()
    let addExercisesLabel = MFTitleLabel(textAlignment: .left, fontSize: 24)
    let saveButton = UIButton()
    
    var workout: Workout!
    
    var exercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureWorkoutTypeLabel()
        configureWorkoutType()
        configureExercisesLabel()
        configureTableView()
//        createDismissKeyboardTapGesture()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Add Workout Details"
        navigationItem.largeTitleDisplayMode = .never
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addButtonTapped() {
        presentAlert()
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
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func configureWorkoutTypeLabel() {
        view.addSubview(workoutTypeLabel)
        workoutTypeLabel.text = "WORKOUT TYPE"
        
        NSLayoutConstraint.activate([
            workoutTypeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            workoutTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            workoutTypeLabel.heightAnchor.constraint(equalToConstant: 30)
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
            workoutTypePickerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureExercisesLabel() {
        view.addSubview(addExercisesLabel)
        addExercisesLabel.text = "Add Exercises"
        
        NSLayoutConstraint.activate([
            addExercisesLabel.topAnchor.constraint(equalTo: workoutTypePickerView.bottomAnchor, constant: 16),
            addExercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addExercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addExercisesLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: view.bounds.height / 3, width: view.bounds.width, height: view.bounds.height)
        tableView.rowHeight = 120
//        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: WorkoutCell.reuseID)
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
    
}

extension AddWorkoutVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return WorkoutType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return WorkoutType.allCases[row].rawValue
    }
    
}
