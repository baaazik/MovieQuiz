//
//  Errors.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 26.04.2025.
//

import Foundation
enum AppError: Error {
    case networkError(Int)
    case apiError(String)
    case unknownError
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .apiError(let errorMessage):
            return "Не удалось загрузить данные: \(errorMessage)"
        case .networkError(let status):
            return "Не удалось загрузить данные: ошибка \(status)"
        case .unknownError:
            return "Неизвестная ошибка"
        }
    }
}
