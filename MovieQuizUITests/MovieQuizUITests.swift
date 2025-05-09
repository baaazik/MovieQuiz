//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Анжелика Забазнова on 28.04.2025.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!


    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        app.terminate()
        app = nil

    }

    func testYesbutton() {
        sleep(5)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap()
        sleep(5)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)

        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }

    func testNoButton() {
        sleep(5)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["No"].tap()
        sleep(5)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)

        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }

    func testAlert() {
        sleep(5)
        for _ in 0..<10 {
            app.buttons["No"].tap()
            sleep(3)
        }

        let alert = app.alerts["Этот раунд окончен!"]

        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }

    func testStartAgain() {
        sleep(5)
        for _ in 0..<10 {
            app.buttons["No"].tap()
            sleep(3)
        }

        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.exists)

        let button = alert.buttons.firstMatch
        button.tap()
        sleep(5)

        let alert1 = app.alerts["Этот раунд окончен!"]
        XCTAssertFalse(alert1.exists)

        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }

}
