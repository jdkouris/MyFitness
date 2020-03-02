//
//  MealDetailsVC.swift
//  MyFitness
//
//  Created by John Kouris on 3/2/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MealDetailsVC: UIViewController {
    
    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    private func configureUIElements(with recipe: Recipe) {
        
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}
