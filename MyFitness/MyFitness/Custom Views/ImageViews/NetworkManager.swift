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
    private let baseURL = "https://api.spoonacular.com/recipes/random/"
    private let apiKey = APIKeys.recipeApiKey
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getRecipes(completion: @escaping (Result<RecipeList, MFError>) -> Void) {
        let queryItems = [URLQueryItem(name: "apiKey", value: apiKey), URLQueryItem(name: "number", value: "2"), URLQueryItem(name: "tag", value: "healthy")]
        var urlComponent = URLComponents(string: baseURL)!
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
}
