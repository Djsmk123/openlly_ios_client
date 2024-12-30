//
//  homeRepo.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//

protocol HomeRepo {
    func getQuestions(completion: @escaping (Result<[Question], Error>) -> Void)
    func getInbox(page: Int, perPage: Int, completion: @escaping (Result<[Answer], Error>) -> Void)
    func seenOneMessage(answerId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class HomeRepoImpl: HomeRepo {
    let networkService: APIClient
    let homeRemoteSource : HomeRemoteSource
    let homeLocalSource: HomeLocalSource
    
    init(networkService: APIClient) {
        self.networkService = networkService
        self.homeRemoteSource = HomeRemoteSource(networkService: networkService)
        self.homeLocalSource = HomeLocalSource()
    }
    
    func getQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        //bool check for internet
        let isConnected = networkService.isConnectedToInternet()    
        if !isConnected {
           //load local
            let questions = homeLocalSource.loadQuestions()
            if questions.isEmpty {
                completion(.failure(APIError.noInternetConnection))
                return
            }
            completion(.success(questions))
            return
        }
        homeRemoteSource.getQuestions(completion: { result in
            switch result {
            case .success(let res):
                //save to local
                res.forEach { question in
                    self.homeLocalSource.saveQuestion(question: question)
                }
                completion(.success(res))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func getInbox(page: Int, perPage: Int, completion: @escaping (Result<[Answer], Error>) -> Void) {        
        homeRemoteSource.getInbox(page: page, perPage: perPage, completion: { result in
            switch result {
            case .success(let res):
                completion(.success(res))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }   
    func seenOneMessage(answerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        homeRemoteSource.seenOneMessage(answerId: answerId, completion: { result in
            switch result {
            case .success(let res):
                completion(.success(res))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}   
