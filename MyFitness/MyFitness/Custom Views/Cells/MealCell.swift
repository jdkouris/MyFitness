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
    let mealTitleLabel = MFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(recipe: Recipe) {
        mealTitleLabel.text = recipe.title
        
        let placeholderImage = UIImage(named: "food-placeholder")
        if let image = recipe.image {
            NetworkManager.shared.downloadImage(from: image) { [weak self](image) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.mealImageView.image = image
                }
            }
        } else {
            DispatchQueue.main.async {
                self.mealImageView.image = placeholderImage
            }
        }
        
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
        cardView.addSubviews(mealImageView, mealTitleLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding / 2),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding / 2),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding / 2),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding / 2),
            
            mealImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            mealImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            mealImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor),
            
            mealTitleLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor),
            mealTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            mealTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            mealTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
