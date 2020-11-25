//
//  ExerciseCategoryCell.swift
//  MyFitness
//
//  Created by John Kouris on 11/24/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class ExerciseCategoryCell: UICollectionViewCell {
    static let reuseID = "ExerciseCategoryCell"
    let categoryImageView = MFExerciseCategoryImageView(frame: .zero)
    let categoryTitleLabel = MFTitleLabel(textAlignment: .center, fontSize: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(category: ExerciseCategory) {
        categoryTitleLabel.text = category.name
        
        let placeholderImage = UIImage(named: "food-placeholder")
        categoryImageView.image = placeholderImage
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
        cardView.addSubviews(categoryImageView, categoryTitleLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding / 2),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding / 2),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding / 2),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding / 2),
            
            categoryImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            categoryImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            categoryImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            categoryImageView.heightAnchor.constraint(equalTo: categoryImageView.widthAnchor),
            
            categoryTitleLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor),
            categoryTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            categoryTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            categoryTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
