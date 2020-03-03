//
//  MFMealInfoHeaderVC.swift
//  MyFitness
//
//  Created by John Kouris on 3/2/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MFMealInfoHeaderVC: UIViewController {
    
    let recipeImageView = MFMealImageView(frame: .zero)
    let recipeNameLabel = MFTitleLabel(textAlignment: .left, fontSize: 30)
    let timeToCookImageView = UIImageView()
    let timeLabel = MFBodyLabel(textAlignment: .left)
    
    var recipe: Recipe!
    
    init(recipe: Recipe) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutUI()
        configureUIElements()
    }
    
    func addSubviews() {
        view.addSubview(recipeImageView)
        view.addSubview(recipeNameLabel)
        view.addSubview(timeToCookImageView)
        view.addSubview(timeLabel)
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        timeToCookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            recipeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func configureUIElements() {
        downloadRecipeImage()
        
        recipeNameLabel.text = recipe.title
        timeLabel.text = String(recipe.readyInMinutes)
        
        timeToCookImageView.image = UIImage(systemName: SFSymbols.timer)
        timeToCookImageView.tintColor = .secondaryLabel
    }
    
    func downloadRecipeImage() {
        NetworkManager.shared.downloadImage(from: recipe.image) { [weak self] (image) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.recipeImageView.image = image
            }
        }
    }

}
