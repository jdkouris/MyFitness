//
//  MFExerciseCategoryImageView.swift
//  MyFitness
//
//  Created by John Kouris on 11/24/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MFExerciseCategoryImageView: UIImageView {

    let placeholderImage = UIImage(named: "food-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

}
