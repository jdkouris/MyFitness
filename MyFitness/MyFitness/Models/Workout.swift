//
//  Workout.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

protocol WorkoutTypeProtocol {
    var description: String { get }
}

enum WorkoutType: Int, CaseIterable, Codable, Hashable, WorkoutTypeProtocol {
    case chest 
    case back
    case quads
    case hamstrings
    case abs
    case biceps
    case triceps
    case shoulders
    case upperBody
    case upperBodyPush
    case upperBodyPull
    case lowerBody
    case fullBody
    case chestBack
    case armsShoulders
    case backBiceps
    case chestTriceps
    
    var description: String {
        switch self {
        case .chest:
            return "Chest"
        case .back:
            return "Back"
        case .quads:
            return "Quadriceps"
        case .hamstrings:
            return "Hamstrings"
        case .abs:
            return "Abs"
        case .biceps:
            return "Biceps"
        case .triceps:
            return "Triceps"
        case .shoulders:
            return "Shoulders"
        case .upperBody:
            return "Upper Body"
        case .upperBodyPush:
            return "Upper Body Push"
        case .upperBodyPull:
            return "Upper Body Pull"
        case .lowerBody:
            return "Lower Body"
        case .fullBody:
            return "Full Body"
        case .chestBack:
            return "Chest & Back"
        case .armsShoulders:
            return "Arms & Shoulders"
        case .backBiceps:
            return "Back & Biceps"
        case .chestTriceps:
            return "Chest & Triceps"
        }
    }
}

struct Workout: Codable, Hashable {
    var id: UUID = UUID()
    var date: Date = Date()
    var workoutType: WorkoutType
    var exercises: [Exercise]
    var notes: String?
}
