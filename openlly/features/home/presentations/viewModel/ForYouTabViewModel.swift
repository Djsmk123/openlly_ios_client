//
//  ForYouTabViewModel.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//

import SwiftUI

import SwiftUI

class ForYouTabViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var questions: [Question] = []
    @Published var loading: Bool = true
    @Published var error: String = ""
    @Published var answers: [Answer] = []
    @Published var answerLoading: Bool = true
    @Published var answerError: String = ""

    private let networkService = APIClient()
    private let homeRepo: HomeRepo
    private var page = 0
    private let perPage = 100
    private var hasMoreAnswers: Bool = true
    @Published var showReplyView: Bool = false

    // Dynamic count of unseen answers
    var unseenAnswerCount: Int {
        answers.filter { !$0.seen }.count
    }

    init() {
        homeRepo = HomeRepoImpl(networkService: networkService)
    }

    func getQuestions() {
        error = ""
        loading = questions.isEmpty || !error.isEmpty

        homeRepo.getQuestions { result in
            DispatchQueue.main.async {
                self.loading = false
                switch result {
                case let .success(questions):
                    self.questions = questions
                case let .failure(error):
                    self.error = error.localizedDescription
                }
            }
        }
    }

    func getAnswers(forceReload: Bool = false) {
        // Start loading if answers are empty or there's an error, but avoid multiple state updates
        if forceReload || answers.isEmpty || !answerError.isEmpty {
            DispatchQueue.main.async {
                self.answerLoading = true
            }
        }

        // Reset pagination and data if we are forcing a reload
        if forceReload {
            DispatchQueue.main.async {
                self.page = 1
                self.answers = []
                self.hasMoreAnswers = true
            }
        }

        // If there's no more data to load, stop loading and return
        guard hasMoreAnswers else {
            DispatchQueue.main.async {
                self.answerLoading = false
            }
            return
        }

        // Call the repository to fetch data
        homeRepo.getInbox(page: page, perPage: perPage) { result in
            DispatchQueue.main.async {
                self.answerLoading = false
                switch result {
                case let .success(newAnswers):
                    // Filter out duplicate answers based on their ID
                    let uniqueAnswers = newAnswers.filter { newAnswer in
                        !self.answers.contains { $0.id == newAnswer.id }
                    }

                    // Update answers depending on the reload flag
                    if forceReload {
                        self.answers = uniqueAnswers
                    } else {
                        self.answers.append(contentsOf: uniqueAnswers)
                    }

                    // Update pagination and check if there are more answers to load
                    if uniqueAnswers.count < self.perPage {
                        self.hasMoreAnswers = false
                    } else {
                        self.page += 1
                    }

                case let .failure(error):
                    // Log error and show error message
                    Logger.logEvent("Error fetching answers: \(error)")
                    DispatchQueue.main.async {
                        self.answerError = error.localizedDescription
                    }
                }
            }
        }
    }

    func markAsSeenOneMessage(answer: Answer) {
        guard !answer.seen else { return }

        homeRepo.seenOneMessage(answerId: answer.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Message marked as seen")
                case let .failure(error):
                    print("Error marking message as seen: \(error)")
                }
            }
        }

        // Update the answer in the array
        DispatchQueue.main.async {
            if let index = self.answers.firstIndex(where: { $0.id == answer.id }) {
                self.answers[index].seen = true
            }
        }
    }

    func presentReplyView(for answer: Answer) {
        // Retrieve the root view controller to present the sheet
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootController = windowScene.windows.first?.rootViewController
        {
            let replyViewController = UIHostingController(rootView: MessageReplyView(answer: answer, onDismiss: {
                // dismiss
                rootController.dismiss(animated: true, completion: nil)
            }))
            replyViewController.modalPresentationStyle = .fullScreen
            replyViewController.view.backgroundColor = .white
            rootController.present(replyViewController, animated: true, completion: nil)
        }
    }
}

let forYouTabViewModel = ForYouTabViewModel()
