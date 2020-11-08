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
    
    var recipeName: String!
    var recipes: [Recipe] = []
    var filteredRecipes: [Recipe] = []
    var isSearching = false
    var activityIndicator: UIActivityIndicatorView?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Recipe>!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getMeals()
        configureDataSource()
    }
    
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
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
//        showLoadingView()
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
    
    func getMeals() {
        NetworkManager.shared.getRecipes { [weak self] result in
            guard let self = self else { return }
            self.hideActivityIndicator()
            
            switch result {
            case .success(let recipes):
                self.recipes.append(contentsOf: recipes.recipes)
                self.updateData(on: self.recipes)
                
            case .failure(let error):
                print("Error fetching: \(error)")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Recipe>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, recipe) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCell.reuseID, for: indexPath) as! MealCell
            cell.set(recipe: recipe)
            return cell
        })
    }
    
    func updateData(on recipes: [Recipe]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipes)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }

}

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
