//
//  Workout.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

enum WorkoutType {
    case chest
    case back
    case quads
    case hamstrings
    case abs
    case upperBody
    case lowerBody
    case fullBody
    case chestBack
    case armsShoulders
    case backBiceps
    case chestTriceps
}

struct Workout {
    var date: Date
    var workoutType: WorkoutType
    var exercises: [Exercise]
    var notes: String?
}
