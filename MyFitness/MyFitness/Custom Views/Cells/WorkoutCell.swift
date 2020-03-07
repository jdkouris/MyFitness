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

    let exerciseNameLabel = MFTitleLabel(textAlignment: .left, fontSize: 24)
    let exerciseWeightLabel = MFSecondaryTitleLabel(fontSize: 24)
    let exerciseRepsLabel = MFSecondaryTitleLabel(fontSize: 24)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(exercise: Exercise) {
        exerciseNameLabel.text = exercise.name
        exerciseWeightLabel.text = "Weight: \(exercise.weight) lbs"
        exerciseRepsLabel.text = "Reps: \(exercise.reps)"
    }
    
    private func configure() {
        addSubview(exerciseNameLabel)
        addSubview(exerciseWeightLabel)
        addSubview(exerciseRepsLabel)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            exerciseNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            exerciseNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            exerciseNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            exerciseWeightLabel.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: 6),
            exerciseWeightLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            exerciseWeightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            exerciseWeightLabel.heightAnchor.constraint(equalToConstant: 30),
            
            exerciseRepsLabel.topAnchor.constraint(equalTo: exerciseWeightLabel.bottomAnchor, constant: 6),
            exerciseRepsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            exerciseRepsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            exerciseRepsLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

}
