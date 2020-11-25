//
//  DemoExercisesVC.swift
//  MyFitness
//
//  Created by John Kouris on 11/24/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class DemoExercisesVC: UIViewController {

    enum Section {
        case main
    }
    
    // MARK: - Variables and Properties
    
    var categories: [ExerciseCategory] = []
    var activityIndicator: UIActivityIndicatorView?
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ExerciseCategory>!
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureCollectionView()
        getDemoExercises()
        configureDataSource()
    }
    
    // MARK: - Configuration Methods
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ExerciseCategoryCell.self, forCellWithReuseIdentifier: ExerciseCategoryCell.reuseID)
        showActivityIndicator()
    }
    
    // MARK: - Data Methods
    
    private func getDemoExercises() {
        NetworkManager.shared.getExerciseCategories { [weak self] result in
            guard let self = self else { return }
            self.hideActivityIndicator()
            
            switch result {
            case .success(let categories):
                self.categories.append(contentsOf: categories.results)
                self.updateData(on: self.categories)
                
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
    }
    
    func updateData(on categories: [ExerciseCategory]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ExerciseCategory>()
        snapshot.appendSections([.main])
        snapshot.appendItems(categories)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ExerciseCategory>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, category) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCategoryCell.reuseID, for: indexPath) as! ExerciseCategoryCell
            cell.set(category: category)
            return cell
        })
    }
    
    
    // MARK: - Activity Indicator Methods
    
    private func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        collectionView.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    
    private func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.stopAnimating()
        }
    }
    
}

extension DemoExercisesVC: UICollectionViewDelegate {
    
}
