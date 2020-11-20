//
//  WeightCell.swift
//  MyFitness
//
//  Created by John Kouris on 3/4/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class WeightCell: UITableViewCell {
    static let reuseID = "WeightCell"
    let titleDateLabel = MFTitleLabel(textAlignment: .left, fontSize: 20)
    let bodyLabel = MFBodyLabel(textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(weight: Weight) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        titleDateLabel.text = dateFormatter.string(from: weight.date ?? Date())
        
        bodyLabel.text = "\(weight.value) lbs"
    }
    
    private func configure() {
        addSubviews(titleDateLabel, bodyLabel)
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            titleDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleDateLabel.heightAnchor.constraint(equalToConstant: 24),
            
            bodyLabel.topAnchor.constraint(equalTo: titleDateLabel.bottomAnchor, constant: padding),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    

}
