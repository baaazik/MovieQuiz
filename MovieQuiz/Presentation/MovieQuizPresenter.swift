//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 01.05.2025.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    weak var viewController: MovieQuizViewController?
    var currentQuestion: QuizQuestion?
    var correctAnswer = 0
    var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticServiceProtocol?

    private var currentQuestionIndex = 0
    



    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }

    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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

    func didReceiveNextQuestion(question: QuizQuestion?) {
        viewController?.hideLoadingIndicator()

        guard let question else {
            return
        }

        currentQuestion = question
        let viewModel =  convert(model: question)
        viewController?.show(quiz: viewModel)
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

}

