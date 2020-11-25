//
//  DemoExercise.swift
//  MyFitness
//
//  Created by John Kouris on 11/24/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

struct Exercises: Codable, Hashable {
    var results: [DemoExercise]
}

struct DemoExercise: Codable, Hashable {
    let id: Int
    let language: Int
    let description: String
    let name: String
    let category: Int
}

struct Categories: Codable, Hashable {
    var results: [ExerciseCategory]
}

struct ExerciseCategory: Codable, Hashable {
    let id: Int
    let name: String
}
