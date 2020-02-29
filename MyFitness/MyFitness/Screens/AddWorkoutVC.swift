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
    let notesLabel = MFTitleLabel(textAlignment: .left, fontSize: 24)
    let workoutNotesTextView = UITextView()
    let addExercisesLabel = MFTitleLabel(textAlignment: .left, fontSize: 24)
    
    var exercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureWorkoutTypeLabel()
        configureWorkoutType()
        configureNotesLabel()
        configureWorkoutNotes()
        configureExercisesLabel()
        configureTableView()
        
        mockExerciseLoad()
//        createDismissKeyboardTapGesture()
    }
    
    func mockExerciseLoad() {
        exercises.append(Exercise(name: "Bench Press", reps: 30, weight: 20))
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Add Workout Details"
        navigationItem.largeTitleDisplayMode = .never
        
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    @objc func saveButtonTapped() {
        
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
    
    private func configureNotesLabel() {
        view.addSubview(notesLabel)
        notesLabel.text = "NOTES"
        
        NSLayoutConstraint.activate([
            notesLabel.topAnchor.constraint(equalTo: workoutTypePickerView.bottomAnchor, constant: 8),
            notesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notesLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureWorkoutNotes() {
        view.addSubview(workoutNotesTextView)
        workoutNotesTextView.translatesAutoresizingMaskIntoConstraints = false
        workoutNotesTextView.layer.cornerRadius = 10
        workoutNotesTextView.layer.borderWidth = 1
        workoutNotesTextView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        
        NSLayoutConstraint.activate([
            workoutNotesTextView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
            workoutNotesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutNotesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            workoutNotesTextView.heightAnchor.constraint(equalToConstant: view.bounds.height / 9)
        ])
    }
    
    private func configureExercisesLabel() {
        view.addSubview(addExercisesLabel)
        addExercisesLabel.text = "Add Exercises"
        
        NSLayoutConstraint.activate([
            addExercisesLabel.topAnchor.constraint(equalTo: workoutNotesTextView.bottomAnchor, constant: 16),
            addExercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addExercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addExercisesLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height)
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
        return WorkoutType.allCases[row].description
    }
    
}
