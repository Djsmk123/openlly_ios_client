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
        self.homeRepo = HomeRepoImpl(networkService: networkService)
    }

    func getQuestions() {
        error = ""
        loading = questions.isEmpty || !error.isEmpty

        homeRepo.getQuestions { result in
            DispatchQueue.main.async {
                self.loading = false
                switch result {
                case .success(let questions):
                    self.questions = questions
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }

    func getAnswers(forceReload: Bool = false) {
        if answers.isEmpty || !answerError.isEmpty {
            answerLoading = true
        }

        if forceReload {
            self.page = 1
            self.answers = []
            self.hasMoreAnswers = true
        }
        if(!hasMoreAnswers){
            return  
        }

        homeRepo.getInbox(page: page, perPage: perPage) { result in
            DispatchQueue.main.async {
                self.answerLoading = false
                switch result {
                case .success(let newAnswers):
                    let uniqueAnswers = newAnswers.filter { newAnswer in
                        !self.answers.contains { $0.id == newAnswer.id }
                    }

                    if forceReload {
                        self.answers = uniqueAnswers
                    } else {
                        self.answers.append(contentsOf: uniqueAnswers)
                    }

                    self.page += 1

                    if uniqueAnswers.count < self.perPage {
                        self.hasMoreAnswers = false
                    }
                case .failure(let error):
                    Logger.logEvent("Error fetching answers: \(error)")
                    self.answerError = error.localizedDescription
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
                case .failure(let error):
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
       let rootController = windowScene.windows.first?.rootViewController {
        let replyViewController = UIHostingController(rootView: MessageReplyView(answer: answer,onDismiss: {
            //dismiss
            rootController.dismiss(animated: true, completion: nil)
        }))
        replyViewController.modalPresentationStyle = .fullScreen
        replyViewController.view.backgroundColor = .white
        rootController.present(replyViewController, animated: true, completion: nil)
    }
}

    
}



let forYouTabViewModel = ForYouTabViewModel()
