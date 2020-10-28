//
//  MFError.swift
//  MyFitness
//
//  Created by John Kouris on 3/2/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

enum MFError: String, Error {
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this recipe. Please try again."
    case alreadyInFavorites = "You've already added this recipe to favorites."
    case unableToSaveWeights = "There was an error saving the weight entries. Please try again."
    case unableToRetrieveWeights = "There was an error retrieving your weight entries. Please try again."
    case unableToSaveWorkouts = "There was an error saving the workouts. Please try again."
    case unableToRetrieveWorkouts = "There was an error retrieving your workouts. Please try again."
}
