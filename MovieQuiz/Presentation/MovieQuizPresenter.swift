//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 01.05.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Public propeties
    
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    var correctAnswer = 0
    var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticServiceProtocol?

    // MARK: - Private properties

    private var currentQuestionIndex = 0
    private weak var viewController: MovieQuizViewController?

    // MARK: - init

    init(viewController: MovieQuizViewController) {
        self.viewController = viewController

        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        loadData()
    }

    // MARK: - QuestionFactoryDelegate

    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: message)
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        viewController?.hideLoadingIndicator()

        guard let question else {
            return
        }

        currentQuestion = question
        let viewModel =  convert(model: question)
        viewController?.show(quiz: viewModel)
    }

    func didFailToLoadImage(with error: Error) {
        viewController?.hideLoadingIndicator()
        viewController?.showImageError()
    }

    // MARK: - Public Methods

    func restartGame() {
        correctAnswer = 0
        currentQuestionIndex = 0
    }

    func requestNextQuestion() {
        // TODO: Check if needed
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func loadData() {
        // TODO: Check if needed
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }

    func yesButtonClicked() {
        guard let question = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: question.correctAnswer)
    }

    func noButtonClicked() {
        guard let question = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: !question.correctAnswer)
    }

    func showNextQuestionOrResults() {
        viewController?.hideBorder()
        viewController?.enableButtons()

        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswer, total: self.questionsAmount)

            var text = "Ваш результат \(correctAnswer)/\(self.questionsAmount)"

            if let statisticService {
                let bestGame = statisticService.bestGame
                text += """

Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
            }

            viewController?.show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"))
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    func didAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
    }

    // MARK: - Private Methods

    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}

