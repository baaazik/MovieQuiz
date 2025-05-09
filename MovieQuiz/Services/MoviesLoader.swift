//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 20.04.2025.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting

    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl, handler: {response in
            switch response {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(MostPopularMovies.self, from: data)
                    if movies.errorMessage != "" {
                        handler(.failure(AppError.apiError(movies.errorMessage)))
                    }
                    else {
                        handler(.success(movies))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        })

    }
}
