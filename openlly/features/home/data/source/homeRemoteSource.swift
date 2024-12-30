//
//  homeRemoteSource.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//


import Foundation

class HomeRemoteSource{
    private let networkService: APIClient

    
    init(networkService: APIClient) {
        self.networkService = networkService
    }
    func getQuestions(completion: @escaping (Result<[Question], APIError>) -> Void) {
        networkService.request(endpoint: "question", type: .get, completion: completion)
    }
    func getInbox(page: Int, perPage: Int, completion: @escaping (Result<[Answer], APIError>) -> Void) {
        var components = URLComponents(string: "user/inbox")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(perPage)")
        ]
        networkService.request(endpoint: components.string!, type: .get, completion: completion)
    }
    func seenOneMessage(answerId: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        networkService.request(endpoint: "user/inbox/seen/\(answerId)", type: .get, completion: { (result: Result<VoidResponse, APIError>) in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
