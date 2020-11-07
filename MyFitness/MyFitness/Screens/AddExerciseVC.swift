//
//  AddExerciseVC.swift
//  MyFitness
//
//  Created by John Kouris on 11/3/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

protocol AddExerciseDelegate {
    func exerciseAdded()
}

class AddExerciseVC: UIViewController {
    
    let cardView = UIView(frame: .zero)
    let exerciseNameTextField = MFTextField()
    let exerciseWeightTextField = MFTextField()
    let exerciseRepsTextField = MFTextField()
    let textFieldStack = UIStackView()
    
    let cancelButton = UIButton(frame: .zero)
    let saveButton = UIButton(frame: .zero)
    let buttonStack = UIStackView()
    
    var exercise: Exercise?
    var workout: Workout?
    var delegate: AddExerciseDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureViews() {
        view.backgroundColor = .clear
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20
        
        exerciseNameTextField.placeholder = "exercise name"
        exerciseWeightTextField.placeholder = "weight lifted"
        exerciseRepsTextField.placeholder = "number of reps"
        
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
        cardView.addSubviews(exerciseNameTextField, exerciseWeightTextField, exerciseRepsTextField, cancelButton, saveButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.bounds.width),
            
            exerciseNameTextField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            exerciseNameTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            exerciseNameTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            exerciseNameTextField.heightAnchor.constraint(equalToConstant: 30),
            
            exerciseWeightTextField.topAnchor.constraint(equalTo: exerciseNameTextField.bottomAnchor, constant: 4),
            exerciseWeightTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            exerciseWeightTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            exerciseWeightTextField.heightAnchor.constraint(equalToConstant: 30),
            
            exerciseRepsTextField.topAnchor.constraint(equalTo: exerciseWeightTextField.bottomAnchor, constant: 4),
            exerciseRepsTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            exerciseRepsTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            exerciseRepsTextField.heightAnchor.constraint(equalToConstant: 30),
            
            cancelButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            cancelButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
        ])
    }
    
    private func updateData() {
//        if self.exercise == nil {
//            self.exercise = Exercise(context: self.context)
//            
//            self.exercise!.name = exerciseNameText
//            self.exercise!.reps = exerciseRepsAsInt
//            self.exercise!.weight = exerciseWeightAsDouble
//            self.exercise!.workout = self.workout
//            
//            self.exercises.append(self.exercise!)
//        } else {
//            self.exercise!.name = exerciseNameText
//            self.exercise!.reps = exerciseRepsAsInt
//            self.exercise!.weight = exerciseWeightAsDouble
//            self.exercise!.workout = self.workout
//            
//            self.exercises.append(self.exercise!)
//        }
//        
//        self.appDelegate.saveContext()
//        self.delegate?.updateWorkout()
    }
    
}
