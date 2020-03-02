//
//  MealCell.swift
//  MyFitness
//
//  Created by John Kouris on 3/2/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MealCell: UICollectionViewCell {
    static let reuseID = "MealCell"
    let mealImageView = MFMealImageView(frame: .zero)
    let mealTitleLabel = MFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(recipe: Recipe) {
        mealTitleLabel.text = recipe.title
        // TODO: - Add networking code to download the recipe image
    }
    
    private func configure() {
        addSubview(mealImageView)
        addSubview(mealTitleLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor),
            
            mealTitleLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 12),
            mealTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mealTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mealTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
