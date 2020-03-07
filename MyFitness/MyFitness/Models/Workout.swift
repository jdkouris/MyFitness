//
//  Workout.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

enum WorkoutType: String, CaseIterable, Codable, Hashable {
    case chest = "Chest"
    case back = "Back"
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case abs = "Abs"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case shoulders = "Shoulders"
    case upperBody = "Upper Body"
    case upperBodyPush = "Upper Body Push"
    case upperBodyPull = "Upper Body Pull"
    case lowerBody = "Lower Body"
    case fullBody = "Full Body"
    case chestBack = "Chest & Back"
    case armsShoulders = "Arms & Shoulders"
    case backBiceps = "Back & Biceps"
    case chestTriceps = "Chest & Tricpes"
}

struct Workout: Codable, Hashable {
    var id: UUID = UUID()
    var date: Date = Date()
    var workoutType: WorkoutType
    var exercises: [Exercise]
    var notes: String?
}
