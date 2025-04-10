//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 05.04.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
