import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IB Outlets
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var correctAnswer = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    private let presenter = MovieQuizPresenter()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        alertPresenter = AlertPresenter(controller: self)
        statisticService = StatisticService()

        showLoadingIndicator()
        questionFactory?.loadData()
    }

    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let question = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: question.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let question = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !question.correctAnswer)
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        hideLoadingIndicator()

        guard let question else {
            return
        }

        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        show(quiz: viewModel)
    }

    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }

    func didFailToLoadImage(with error: Error) {
        showImageError()
    }

    // MARK: - Private Methods
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswer += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswer, total: presenter.questionsAmount)

            var text = "Ваш результат \(correctAnswer)/\(presenter.questionsAmount)"

            if let statisticService {
                let bestGame = statisticService.bestGame
                text += """

Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
            }

            show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"))
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let completion = { [weak self] in
            guard let self = self else { return }
            self.presenter.resetQuestionIndex()
            self.correctAnswer = 0
            self.questionFactory?.requestNextQuestion()
        }

        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: completion)

        alertPresenter?.show(model: model)
    }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }

                self.presenter.resetQuestionIndex()
                self.correctAnswer = 0

                self.showLoadingIndicator()
                self.questionFactory?.loadData()
            })

        alertPresenter?.show(model: model)
    }

    private func showImageError() {
        hideLoadingIndicator()
        let model = AlertModel(
            title: "Ошибка",
            message: "Не удалось загрузить изображение",
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.showLoadingIndicator()
                self.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.show(model: model)
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
