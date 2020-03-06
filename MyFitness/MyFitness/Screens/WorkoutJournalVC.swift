//
//  WorkoutJournalVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class WorkoutJournalVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Workout>!
    var workouts = [Workout]()
    
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
        
        mockWorkoutsLoad()
    }
    
    func mockWorkoutsLoad() {
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 16, weight: 0)], notes: "Short ab workout"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .chest, exercises: [Exercise(name: "Bench Press", reps: 12, weight: 180)], notes: "Short chest workout. Went for high reps, lighter weights. Started to feel tired later. balskdflkansdlfkanslfkjasldfkjaosdifnalsdknflaksdnflsdkflaksdnf"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 12, weight: 0)], notes: "Short ab workout"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 12, weight: 0)], notes: "Short ab workout"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 12, weight: 0)], notes: "Short ab workout"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 12, weight: 0)], notes: "Short ab workout"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 12, weight: 0)], notes: "Short ab workout"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 12, weight: 0)], notes: "Short ab workout"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 12, weight: 0)], notes: "Short ab workout"))
        workouts.append(Workout(id: UUID(), date: Date(), workoutType: .abs, exercises: [Exercise(name: "Crunch", reps: 12, weight: 0)], notes: "Short ab workout"))
        updateData(on: workouts)
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
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Workout>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, workout) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JournalCell.reuseID, for: indexPath) as! JournalCell
            cell.set(workout: workout)
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
        let addWorkoutVC = AddWorkoutVC()
        navigationController?.pushViewController(addWorkoutVC, animated: true)
    }

}

extension WorkoutJournalVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workout = workouts[indexPath.item]
        
        let destinationVC = AddWorkoutVC()
        
    }
}
