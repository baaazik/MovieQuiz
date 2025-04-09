//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 05.04.2025.
//

import UIKit

class AlertPresenter {
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

    weak private var controller: UIViewController?

    init(controller: UIViewController) {
        self.controller = controller
    }
}
