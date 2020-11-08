//
//  JournalCell.swift
//  MyFitness
//
//  Created by John Kouris on 2/27/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class JournalCell: UITableViewCell {
    static let reuseID = "JournalCell"
    let titleDateLabel = MFTitleLabel(textAlignment: .left, fontSize: 20)
    let workoutTypeLabel = MFSecondaryTitleLabel(fontSize: 18)
    let bodyLabel = MFBodyLabel(textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(workout: Workout) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        titleDateLabel.text = dateFormatter.string(from: Date())
        workoutTypeLabel.text = workout.name
        bodyLabel.text = workout.notes
    }
    
    private func configure() {
        let cardView = UIView(frame: self.frame)
        cardView.backgroundColor = .systemGray6
        cardView.layer.cornerRadius = 10
        
        self.contentView.addSubview(cardView)
        cardView.addSubviews(titleDateLabel, workoutTypeLabel, bodyLabel)
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleDateLabel.topAnchor.constraint(equalTo: cardView.topAnchor),
            titleDateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            titleDateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            titleDateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            workoutTypeLabel.topAnchor.constraint(equalTo: titleDateLabel.bottomAnchor, constant: padding / 2),
            workoutTypeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            workoutTypeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            workoutTypeLabel.heightAnchor.constraint(equalToConstant: 24),

            bodyLabel.topAnchor.constraint(equalTo: workoutTypeLabel.bottomAnchor, constant: padding),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding)
        ])
    }
    
}
