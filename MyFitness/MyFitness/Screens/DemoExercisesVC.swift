//
//  DemoExercisesVC.swift
//  MyFitness
//
//  Created by John Kouris on 11/24/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class DemoExercisesVC: UIViewController {

    var categories: [ExerciseCategory] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDemoExercises()
    }
    
    private func getDemoExercises() {
        NetworkManager.shared.getExerciseCategories { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let categories):
                self.categories.append(contentsOf: categories.results)
                print(self.categories)
                
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
    }
    
}
