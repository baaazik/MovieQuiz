//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 01.05.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Public propeties

    // MARK: - Private properties

    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var correctAnswer = 0
    private var currentQuestionIndex = 0
    private var statisticService: StatisticServiceProtocol
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?

    // MARK: - init

    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
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
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func loadData() {
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }

    func yesButtonClicked() {
        guard let question = currentQuestion else {
            return
        }
        proceedWithAnswer(isCorrect: question.correctAnswer)
    }

    func noButtonClicked() {
        guard let question = currentQuestion else {
            return
        }
        proceedWithAnswer(isCorrect: !question.correctAnswer)
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    // MARK: - Private Methods

    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        viewController?.disableButtons()

        if isCorrect {
            correctAnswer += 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }

    private func proceedToNextQuestionOrResults() {
        viewController?.hideBorder()
        viewController?.enableButtons()

        if self.isLastQuestion() {
            statisticService.store(correct: correctAnswer, total: self.questionsAmount)

            var text = "Ваш результат \(correctAnswer)/\(self.questionsAmount)"

            let bestGame = statisticService.bestGame
            text += """

Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""

            viewController?.show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
            requestNextQuestion()
        }
    }

}

