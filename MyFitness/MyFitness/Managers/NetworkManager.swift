//
//  NetworkManager.swift
//  MyFitness
//
//  Created by John Kouris on 3/2/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let recipeBaseURL = "https://api.spoonacular.com/recipes/random/"
    private let recipeApiKey = APIKeys.recipeApiKey
    let cache = NSCache<NSString, UIImage>()
    
    private let exerciseBaseURL = "https://wger.de/api/v2/"
    private let exerciseApiKey = APIKeys.exerciseApiKey
    
    private init() {}
    
    // MARK: - Recipe methods
    
    func getRecipes(completion: @escaping (Result<RecipeList, MFError>) -> Void) {
        let queryItems = [URLQueryItem(name: "apiKey", value: recipeApiKey),
                          URLQueryItem(name: "number", value: "20"),
                          URLQueryItem(name: "tag", value: "healthy")]
        var urlComponent = URLComponents(string: recipeBaseURL)!
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidResponse))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let recipes = try decoder.decode(RecipeList.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(recipes))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Exercise methods
    
    func getExerciseCategories(completion: @escaping (Result<Categories, MFError>) -> Void) {
        let exerciseCategoryURLString = exerciseBaseURL + "/exercisecategory/"
        guard let url = URL(string: exerciseCategoryURLString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token \(exerciseApiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let categories = try decoder.decode(Categories.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(categories))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
            }
        }
        
        task.resume()
        
    }
    
    func getExercises(completion: @escaping (Result<Exercises, MFError>) -> Void) {
        let exercisesURLString = exerciseBaseURL + "/exercise/"
        guard let url = URL(string: exercisesURLString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token \(exerciseApiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let exercises = try decoder.decode(Exercises.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(exercises))
                    print(exercises)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
            }
        }
        
        task.resume()
    }
    
}

