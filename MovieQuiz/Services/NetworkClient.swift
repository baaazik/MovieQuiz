//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 20.04.2025.
//

import Foundation

struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.codeError))
                return
            }

            guard (200..<300).contains(response.statusCode) else {
                handler(.failure(NetworkError.codeError))
                return
            }

            guard let data = data else { return }
            handler(.success(data))
        }

        task.resume()
    }
}
