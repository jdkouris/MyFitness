//
//  MealsVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MealsVC: UIViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - Variables and Properties
    
    var recipes: [Recipe] = []
    var filteredRecipes: [Recipe] = []
    var isSearching = false
    var activityIndicator: UIActivityIndicatorView?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Recipe>!
    
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
        configureSearchController()
        getMeals()
        configureDataSource()
    }
    
    // MARK: - Configuration Methods
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshRecipes))
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MealCell.self, forCellWithReuseIdentifier: MealCell.reuseID)
        showActivityIndicator()
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a recipe"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    @objc func refreshRecipes() {
        showActivityIndicator()
        getMeals()
    }
    
    // MARK: - Data Methods
    
    func getMeals() {
        recipes.removeAll()
        NetworkManager.shared.getRecipes { [weak self] result in
            guard let self = self else { return }
            self.hideActivityIndicator()
            
            switch result {
            case .success(let recipes):
                self.recipes.append(contentsOf: recipes.recipes)
                self.updateData(on: self.recipes)
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                
            case .failure(let error):
                self.presentMFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Dismiss")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    func updateData(on recipes: [Recipe]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipes)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Recipe>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, recipe) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCell.reuseID, for: indexPath) as! MealCell
            cell.set(recipe: recipe)
            return cell
        })
    }
    
    // MARK: Activity Indicator Methods
    
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

// MARK: - Extensions

extension MealsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredRecipes : recipes
        let recipe = activeArray[indexPath.item]
        
        let destinationVC = MealDetailsVC()
        destinationVC.recipe = recipe
        
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true, completion: nil)
    }
}

extension MealsVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredRecipes = recipes.filter { $0.title.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredRecipes)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: recipes)
    }
}
