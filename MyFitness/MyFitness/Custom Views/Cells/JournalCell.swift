//
//  JournalCell.swift
//  MyFitness
//
//  Created by John Kouris on 2/27/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class JournalCell: UICollectionViewCell {
    static let reuseID = "JournalCell"
    let titleDateLabel = MFTitleLabel(textAlignment: .left, fontSize: 20)
    let workoutTypeLabel = MFSecondaryTitleLabel(fontSize: 18)
    let bodyLabel = MFBodyLabel(textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(workout: Workout) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        titleDateLabel.text = dateFormatter.string(from: Date())
        workoutTypeLabel.text = workout.workoutType.rawValue
        bodyLabel.text = workout.notes
    }
    
    private func configure() {
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 10
        addSubview(titleDateLabel)
        addSubview(workoutTypeLabel)
        addSubview(bodyLabel)
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            titleDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleDateLabel.heightAnchor.constraint(equalToConstant: 24),
            
            workoutTypeLabel.topAnchor.constraint(equalTo: titleDateLabel.bottomAnchor, constant: padding / 2),
            workoutTypeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            workoutTypeLabel.heightAnchor.constraint(equalToConstant: 24),
            
            bodyLabel.topAnchor.constraint(equalTo: workoutTypeLabel.bottomAnchor, constant: padding),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            bodyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
    
}
