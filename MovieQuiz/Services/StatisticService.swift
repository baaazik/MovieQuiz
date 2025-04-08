//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 07.04.2025.
//

import Foundation

class StatisticService: StatisticServiceProtocol {
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
        case date
        case correctAnswers
        case totalAnswers

    }

    private let storage: UserDefaults = .standard

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.correct.rawValue)
            let total = storage.integer(forKey: Keys.total.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()

            return GameResult(correct: correct, total: total, date: date)

        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }

    var totalAccuracy: Double {
        if totalAnswers != 0 {
            return Double(correctAnswers) / Double(totalAnswers)
        }
        return 0
    }

    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }

    private var totalAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAnswers.rawValue)
        }
    }

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correctAnswers += count
        totalAnswers += amount
        let currentResult = GameResult(correct: count, total: amount, date: Date())

        if currentResult.compare(other: bestGame) {
            bestGame = currentResult
        }
    }
    

}
