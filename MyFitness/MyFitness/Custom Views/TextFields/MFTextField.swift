//
//  MFTextField.swift
//  MyFitness
//
//  Created by John Kouris on 2/29/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        tintColor = .label
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        autocorrectionType = .no
        clearButtonMode = .whileEditing
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 6, width: self.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 48 / 255, green: 173 / 255, blue: 99 / 255, alpha: 1).cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }

}
