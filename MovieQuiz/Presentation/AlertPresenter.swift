//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 05.04.2025.
//

import UIKit

final class AlertPresenter {
    weak private var controller: UIViewController?

    init(controller: UIViewController) {
        self.controller = controller
    }

    func show(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }

        alert.addAction(action)

        controller?.present(alert, animated: true, completion: nil)
    }
}
