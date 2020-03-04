//
//  ProgressVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import Charts

class ProgressVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        layoutUIElements()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addButtonTapped() {
        
    }
    
    func layoutUIElements() {
        
    }
    
}
