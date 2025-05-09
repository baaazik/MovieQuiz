//
//  PresenterTests.swift
//  MovieQuizTests
//
//  Created by Анжелика Забазнова on 03.05.2025.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {

    }
    
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {

    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {

    }
    
    func hideBorder() {

    }
    
    func showLoadingIndicator() {

    }
    
    func hideLoadingIndicator() {

    }
    
    func showNetworkError(message: String) {

    }
    
    func showImageError() {

    }
    
    func enableButtons() {

    }
    
    func disableButtons() {

    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }

}
