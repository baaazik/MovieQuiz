//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 30.03.2025.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {

    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]

    weak var delegate: QuestionFactoryDelegate?
    private var currentRoundQuestions: [QuizQuestion] = []

    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
        self.currentRoundQuestions = questions.shuffled()
    }

    func requestNextQuestion() {
        if currentRoundQuestions.isEmpty {
            currentRoundQuestions = questions.shuffled()
        }

        let nextQuestion = currentRoundQuestions.removeFirst()
        delegate?.didReceiveNextQuestion(question: nextQuestion)
    }
}
