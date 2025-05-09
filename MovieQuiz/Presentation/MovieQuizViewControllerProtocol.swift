//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 03.05.2025.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)

    func highlightImageBorder(isCorrectAnswer: Bool)
    func hideBorder()

    func showLoadingIndicator()
    func hideLoadingIndicator()

    func showNetworkError(message: String)
    func showImageError()

    func enableButtons()
    func disableButtons()

    
}
