//
//  WorkoutJournalVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutJournalVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Workout>!
    var workouts = [Workout]()
    let healthStore = HKHealthStore()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWorkouts()
        if HKHealthStore.isHealthDataAvailable() {
            
        }
    }
    
    func getWorkouts() {
        PersistenceManager.retrieveWorkouts { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let workouts):
                if workouts.isEmpty {
                    print("no workouts saved")
                } else {
                    self.workouts = workouts
                    self.updateData(on: workouts)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("Error retrieving workouts: \(error)")
            }
        }
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createSingleColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(JournalCell.self, forCellWithReuseIdentifier: JournalCell.reuseID)
    }
    
    @objc func swipeToDelete(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! JournalCell
        let itemIndex = self.collectionView.indexPath(for: cell)!.item
        
        let workout = workouts[itemIndex]
        
        workouts.remove(at: itemIndex)
        updateData(on: workouts)
        
        PersistenceManager.updateWith(workout: workout, actionType: .remove) { (error) in
            guard let error = error else { return }
            print("unable to remove: \(error)")
        }
        
        self.collectionView.reloadData()
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Workout>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, workout) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JournalCell.reuseID, for: indexPath) as! JournalCell
            cell.set(workout: workout)
            
            let swipeAction = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToDelete(sender:)))
            swipeAction.direction = UISwipeGestureRecognizer.Direction.right
            cell.addGestureRecognizer(swipeAction)
            
            return cell
        })
    }
    
    func updateData(on workouts: [Workout]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Workout>()
        snapshot.appendSections([.main])
        snapshot.appendItems(workouts)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    @objc func addButtonTapped() {
        let destinationVC = AddWorkoutVC()
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true, completion: nil)
    }

}

extension WorkoutJournalVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workout = workouts[indexPath.item]
        
        let destinationVC = AddWorkoutVC()
        destinationVC.workout = workout
        destinationVC.notesTextView.text = workout.notes
        destinationVC.delegate = self
        
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true, completion: nil)
    }
}

extension WorkoutJournalVC: AddWorkoutVCDelegate {
    func updateWorkout() {
        getWorkouts()
        collectionView.reloadData()
    }
}
