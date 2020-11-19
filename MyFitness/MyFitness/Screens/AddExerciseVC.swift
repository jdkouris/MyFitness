//
//  AddExerciseVC.swift
//  MyFitness
//
//  Created by John Kouris on 11/3/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import CoreData

protocol AddExerciseDelegate {
    func exerciseAdded()
}

class AddExerciseVC: UIViewController {
    
    // MARK: - Properties and Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let cardView = UIView(frame: .zero)
    let exerciseNameTextField = MFTextField()
    let exerciseWeightTextField = MFTextField()
    let exerciseRepsTextField = MFTextField()
    let numberOfSetsTextField = MFTextField()
    
    let cancelButton = UIButton(frame: .zero)
    let saveButton = UIButton(frame: .zero)
    
    var exercise: Exercise?
    var workout: Workout?
    var delegate: AddExerciseDelegate?
    
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
        configureCancelButton()
        configureSaveButton()
        configureViews()
        layoutUI()
    }
    
    // MARK: - Configure Button Actions
    
    private func configureCancelButton() {
        cancelButton.addTarget(self, action: #selector(dismissAddExercise), for: .touchUpInside)
    }
    
    @objc func dismissAddExercise() {
        workout = nil
        dismiss(animated: true, completion: nil)
    }
    
    private func configureSaveButton() {
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
    }
    
    @objc func saveAction() {
        guard let name = exerciseNameTextField.text, let reps = Int64(exerciseRepsTextField.text!), let weight = Double(exerciseWeightTextField.text!) else { return }
        if exercise == nil {
            self.exercise = Exercise(context: context)
            
            exercise!.name = name
            exercise!.reps = reps
            exercise!.weight = weight
            exercise!.workout = workout
        } else {
            exercise?.name = name
            exercise?.reps = reps
            exercise?.weight = weight
            exercise?.workout = workout
        }
        
        appDelegate.saveContext()
        
        delegate?.exerciseAdded()
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configure Views and Layout UI
    
    private func configureViews() {
        view.backgroundColor = .clear
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        
        exerciseNameTextField.placeholder = "exercise name"
        exerciseNameTextField.becomeFirstResponder()
        
        exerciseWeightTextField.placeholder = "weight lifted"
        exerciseWeightTextField.keyboardType = .decimalPad
        
        exerciseRepsTextField.placeholder = "number of reps"
        exerciseRepsTextField.keyboardType = .numberPad
        
        numberOfSetsTextField.placeholder = "number of sets"
        numberOfSetsTextField.keyboardType = .numberPad
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.cornerRadius = 20
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = .blue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 20
        saveButton.setTitle("Save", for: .normal)
    }
    
    private func layoutUI() {
        view.addSubview(cardView)
        cardView.addSubviews(exerciseNameTextField,
                             exerciseWeightTextField,
                             exerciseRepsTextField,
                             numberOfSetsTextField,
                             cancelButton,
                             saveButton)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            cardView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.bounds.width + 20),
            
            exerciseNameTextField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            exerciseNameTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            exerciseNameTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            exerciseNameTextField.heightAnchor.constraint(equalToConstant: 30),
            
            exerciseWeightTextField.topAnchor.constraint(equalTo: exerciseNameTextField.bottomAnchor, constant: 4),
            exerciseWeightTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            exerciseWeightTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            exerciseWeightTextField.heightAnchor.constraint(equalToConstant: 30),
            
            exerciseRepsTextField.topAnchor.constraint(equalTo: exerciseWeightTextField.bottomAnchor, constant: 4),
            exerciseRepsTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            exerciseRepsTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            exerciseRepsTextField.heightAnchor.constraint(equalToConstant: 30),
            
            numberOfSetsTextField.topAnchor.constraint(equalTo: exerciseRepsTextField.bottomAnchor, constant: 4),
            numberOfSetsTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            numberOfSetsTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            numberOfSetsTextField.heightAnchor.constraint(equalToConstant: 30),
            
            cancelButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -padding/2),
            cancelButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            cancelButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding),
        ])
    }
    
    
    
}
