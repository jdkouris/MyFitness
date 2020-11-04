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
        
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .equalSpacing
        textFieldStack.alignment = .fill
        textFieldStack.addArrangedSubviews(exerciseNameTextField, exerciseWeightTextField, exerciseRepsTextField)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.cornerRadius = 20
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = .blue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 20
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .fill
        buttonStack.addArrangedSubviews(cancelButton, saveButton)
    }
    
    private func layoutUI() {
        view.addSubview(cardView)
        cardView.addSubviews(textFieldStack, buttonStack)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.bounds.width),
            
            textFieldStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            textFieldStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            textFieldStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            textFieldStack.heightAnchor.constraint(equalToConstant: 200),
            
            buttonStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            buttonStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            buttonStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            buttonStack.heightAnchor.constraint(equalToConstant: 100)
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
