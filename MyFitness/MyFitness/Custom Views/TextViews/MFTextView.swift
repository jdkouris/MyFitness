//
//  MFTextView.swift
//  MyFitness
//
//  Created by John Kouris on 3/3/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MFTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        font = UIFont.systemFont(ofSize: 14)
        
        isEditable = false
        isSelectable = false
        isScrollEnabled = true
    }

}
