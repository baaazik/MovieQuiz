//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 20.04.2025.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                handler(.failure(AppError.unknownError))
                return
            }

            guard (200..<300).contains(response.statusCode) else {
                handler(.failure(AppError.networkError(response.statusCode)))
                return
            }

            guard let data = data else { return }
            handler(.success(data))
        }

        task.resume()
    }
}
