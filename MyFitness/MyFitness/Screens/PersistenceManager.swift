//
//  PersistenceManager.swift
//  MyFitness
//
//  Created by John Kouris on 3/5/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let weightEntry = "weightEntry"
    }
    
    static func updateWith(weight: Double, actionType: PersistenceActionType, completion: @escaping (MFError?) -> Void) {
        retrieveWeights { (result) in
            switch result {
            case .success(let weights):
                var retrievedWeights = weights
                
                switch actionType {
                case .add:
                    retrievedWeights.append(weight)
                }
                
                completion(save(weightEntries: retrievedWeights))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func retrieveWeights(completion: @escaping (Result<[Double], MFError>) -> Void) {
        guard let weightsData = defaults.object(forKey: Keys.weightEntry) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let weights = try decoder.decode([Double].self, from: weightsData)
            completion(.success(weights))
        } catch {
            completion(.failure(.unableToRetrieveWeights))
        }
    }
    
    static func save(weightEntries: [Double]) -> MFError? {
        do {
            let encoder = JSONEncoder()
            let encodedWeights = try encoder.encode(weightEntries)
            defaults.set(encodedWeights, forKey: Keys.weightEntry)
            return nil
        } catch {
            return .unableToSaveWeights
        }
    }
}
