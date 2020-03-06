//
//  MFTabBarController.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = .systemBlue
        viewControllers = [createWorkoutJournalNC(), createProgressNC(), createMealsNC(), createGymFinderNC()]
    }
    
    func createWorkoutJournalNC() -> UINavigationController {
        let workoutJournalVC = WorkoutJournalVC()
        workoutJournalVC.title = "Workouts"
        workoutJournalVC.tabBarItem = UITabBarItem(title: "Journal", image: UIImage(systemName: SFSymbols.journal), tag: 0)
        
        return UINavigationController(rootViewController: workoutJournalVC)
    }
    
    func createProgressNC() -> UINavigationController {
        let progressVC = ProgressVC()
        progressVC.title = "Progress"
        progressVC.tabBarItem = UITabBarItem(title: "Progress", image: UIImage(systemName: SFSymbols.progress), tag: 1)
        
        return UINavigationController(rootViewController: progressVC)
    }
    
    func createMealsNC() -> UINavigationController {
        let mealsVC = MealsVC()
        mealsVC.title = "Recipes"
        mealsVC.tabBarItem = UITabBarItem(title: "Recipes", image: UIImage(systemName: SFSymbols.recipe), tag: 2)
        
        return UINavigationController(rootViewController: mealsVC)
    }
    
    func createGymFinderNC() -> UINavigationController {
        let gymFinderVC = GymFinderVC()
        gymFinderVC.title = "Find Gym"
        gymFinderVC.tabBarItem = UITabBarItem(title: "Gym Finder", image: UIImage(systemName: SFSymbols.gymSearch), tag: 3)
        
        return UINavigationController(rootViewController: gymFinderVC)
    }

}
