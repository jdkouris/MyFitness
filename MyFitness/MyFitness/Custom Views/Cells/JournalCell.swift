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
        
        bodyLabel.text = workout.notes
    }
    
    private func configure() {
        addSubview(titleDateLabel)
        addSubview(bodyLabel)
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            titleDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleDateLabel.heightAnchor.constraint(equalToConstant: 80),
            
            bodyLabel.topAnchor.constraint(equalTo: titleDateLabel.bottomAnchor, constant: padding),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            bodyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
    
}
