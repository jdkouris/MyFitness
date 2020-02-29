//
//  WorkoutCell.swift
//  MyFitness
//
//  Created by John Kouris on 2/27/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {
    static let reuseID = "WorkoutCell"

    let exerciseNameTextField = MFTextField()
    let exerciseWeightTextField = MFTextField()
    let exerciseRepsTextField = MFTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(exercise: Exercise) {
        exerciseNameTextField.text = exercise.name
        exerciseWeightTextField.text = String(exercise.weight)
        exerciseRepsTextField.text = String(exercise.reps)
    }
    
    private func configure() {
        addSubview(exerciseNameTextField)
        addSubview(exerciseWeightTextField)
        addSubview(exerciseRepsTextField)
        
        exerciseNameTextField.placeholder = "Exercise name"
        exerciseWeightTextField.placeholder = "Weight"
        exerciseRepsTextField.placeholder = "Reps"
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            exerciseNameTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            exerciseNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            exerciseNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            exerciseNameTextField.heightAnchor.constraint(equalToConstant: 30),
            
            exerciseWeightTextField.topAnchor.constraint(equalTo: exerciseNameTextField.bottomAnchor, constant: 6),
            exerciseWeightTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            exerciseWeightTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            exerciseWeightTextField.heightAnchor.constraint(equalToConstant: 30),
            
            exerciseRepsTextField.topAnchor.constraint(equalTo: exerciseWeightTextField.bottomAnchor, constant: 6),
            exerciseRepsTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            exerciseRepsTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            exerciseRepsTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

}
