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

            let movie = currentRoundMovies.removeFirst()

            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }

            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 8?"
            let correctAnswer = rating > 8

            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
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
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
