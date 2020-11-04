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
    let exerciseNameTextField = UITextField(frame: .zero)
    let exerciseWeightTextField = UITextField(frame: .zero)
    let exerciseRepsTextField = UITextField(frame: .zero)
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
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .equalSpacing
        textFieldStack.addArrangedSubviews(exerciseNameTextField, exerciseWeightTextField, exerciseRepsTextField)
        
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubviews(cancelButton, saveButton)
        
    }
    
    private func layoutUI() {
        view.addSubview(cardView)
        cardView.addSubviews(textFieldStack, buttonStack)
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
