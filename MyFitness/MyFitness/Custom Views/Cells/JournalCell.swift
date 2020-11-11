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
        let cardView = UIView(frame: self.contentView.frame)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 4
        
        addSubview(cardView)
        cardView.addSubviews(titleDateLabel, workoutTypeLabel, bodyLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding / 2),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding / 2),
            
            titleDateLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            titleDateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            titleDateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            titleDateLabel.heightAnchor.constraint(equalToConstant: 30),

            workoutTypeLabel.topAnchor.constraint(equalTo: titleDateLabel.bottomAnchor),
            workoutTypeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            workoutTypeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            workoutTypeLabel.heightAnchor.constraint(equalToConstant: 24),

            bodyLabel.topAnchor.constraint(equalTo: workoutTypeLabel.bottomAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding)
        ])
    }
    
}
