//
//  MFAlertContainerView.swift
//  MyFitness
//
//  Created by John Kouris on 12/4/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MFAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }

}
