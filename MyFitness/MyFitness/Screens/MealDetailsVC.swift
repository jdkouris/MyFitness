//
//  MealDetailsVC.swift
//  MyFitness
//
//  Created by John Kouris on 3/2/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MealDetailsVC: UIViewController {
    
    let headerView = UIView()
    let recipeInstructionsTextView = MFTextView()
    
    var itemViews: [UIView] = []
    
    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        configureUIElements(with: recipe)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    private func configureUIElements(with recipe: Recipe) {
        self.add(childVC: MFMealInfoHeaderVC(recipe: recipe), to: self.headerView)
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}
