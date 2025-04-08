//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 07.04.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func compare(other: GameResult) -> Bool {
        self.correct > other.correct
    }
}

