//
//  UIStackView+Extension.swift
//  MyFitness
//
//  Created by John Kouris on 11/3/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
}
