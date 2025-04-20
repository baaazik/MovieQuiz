//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 03.04.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
