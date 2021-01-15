//
//  PlaceCell.swift
//  MyFitness
//
//  Created by John Kouris on 12/28/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {
    static let reuseID = "PlaceCell"
    let placeNameLabel = MFTitleLabel(textAlignment: .left, fontSize: 18)
    let addressLabel = MFBodyLabel(textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(place: Place) {
        placeNameLabel.text = place.name
        addressLabel.text = place.address
    }
    
    private func configure() {
        let cardView = UIView(frame: self.contentView.frame)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 2
        
        selectionStyle = .none
        
        addSubview(cardView)
        cardView.addSubviews(placeNameLabel, addressLabel)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding / 2),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding / 2),
            
            placeNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            placeNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            placeNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            placeNameLabel.heightAnchor.constraint(equalToConstant: 26),

            addressLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            addressLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding)
        ])
        
        
    }

}
