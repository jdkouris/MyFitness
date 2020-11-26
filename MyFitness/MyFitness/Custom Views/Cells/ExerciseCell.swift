//
//  ExerciseCell.swift
//  MyFitness
//
//  Created by John Kouris on 11/25/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {
    static let reuseID = "ExerciseCell"
    let exerciseNameLabel = MFTitleLabel(textAlignment: .left, fontSize: 20)
    let exerciseDescriptionLabel = MFBodyLabel(textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(exercise: DemoExercise) {
        exerciseNameLabel.text = exercise.name
        exerciseDescriptionLabel.text = exercise.description
    }
    
    private func configure() {
        let cardView = UIView(frame: self.contentView.frame)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 1
        
        exerciseDescriptionLabel.textAlignment = .natural
        selectionStyle = .none
        
        addSubview(cardView)
        cardView.addSubviews(exerciseNameLabel, exerciseDescriptionLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding / 2),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding / 2),
            
            exerciseNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            exerciseNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            exerciseNameLabel.heightAnchor.constraint(equalToConstant: 30),

            exerciseDescriptionLabel.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor),
            exerciseDescriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            exerciseDescriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            exerciseDescriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding)
        ])
    }
    
}
