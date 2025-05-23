//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 30.03.2025.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak private var delegate: QuestionFactoryDelegate?
    private var currentRoundMovies: [MostPopularMovie] = []
    private var movies: [MostPopularMovie] = []
    private var medianRating: Float = 0

    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            if currentRoundMovies.isEmpty {
                currentRoundMovies = movies.shuffled()
            }

            let movie = currentRoundMovies.first
            guard let movie else {
                return
            }

            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadImage(with: error)
                }
                return
            }

            let rating = Float(movie.rating) ?? 0
            var correctAnswer = false
            var comparison = ""

            /* Задаем вопросы, сравнивая с медианным значением рейтинга.
             * Таким образом, половина фильмов имеет рейтинг меньше, половина - больше,
             * и квиз честный
             */

            let choice = Int.random(in: 0...1)
            if choice == 1 {
                comparison = "больше"
                correctAnswer = rating > medianRating
            }
            else {
                comparison = "меньше"
                correctAnswer = rating < medianRating
            }

            let text = "Рейтинг этого фильма \(comparison) чем \(medianRating)?"

            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)

            currentRoundMovies.removeFirst()

            DispatchQueue.main.async {
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.currentRoundMovies = self.movies.shuffled()
                    self.medianRating = calcMedian(movies: self.movies)
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
