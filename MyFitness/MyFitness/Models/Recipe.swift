//
//  Meal.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

struct RecipeList: Codable, Hashable {
    var recipes: [Recipe]
}

struct Recipe: Codable, Hashable {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let image: String
    let summary: String
    let instructions: String
    let extendedIngredients: [Ingredients]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Ingredients: Codable, Hashable {
    var originalString: String
}
