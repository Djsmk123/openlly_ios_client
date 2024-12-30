//
//  firebaseRemoteConfig.swift
//  openlly
//
//  Created by Mobin on 30/12/24.
//

import Foundation
import FirebaseRemoteConfig

struct FirebaseRemoteConfigModel: Decodable {
    let apiBaseUrl: String
    let facebookAppId: String
}

class FirebaseRemoteService {
    static let shared = FirebaseRemoteService()
    private let remoteConfig: RemoteConfig

    var remoteConfigModel: FirebaseRemoteConfigModel?
    var errorMessage: String?

    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 // Set to 0 for development, increase for production
        remoteConfig.configSettings = settings
    }

    func fetchAndActivateRemoteConfig(complete: @escaping (Result<Void, Error>) -> Void) {
        if remoteConfigModel != nil {
            complete(.success(()))
            return
        }

        // Fetch remote config on initialization
        fetchFirebaseRemoteConfig { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let configModel):
                    self?.remoteConfigModel = configModel
                    complete(.success(()))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    complete(.failure(error))
                }
            }
        }
    }
    
    /// Fetches and decodes the remote config values into a `FirebaseRemoteConfigModel`.
    func fetchFirebaseRemoteConfig(completion: @escaping (Result<FirebaseRemoteConfigModel, Error>) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                // Safely access the value of "app_configs" from remote config
                let appConfigsString = self.remoteConfig.configValue(forKey: "app_configs").stringValue
                Logger.logEvent("Remote Config fetched: \(appConfigsString)")
                
                // Convert the string to Data
                guard let data = appConfigsString.data(using: .utf8) else {
                    completion(.failure(NSError(domain: "RemoteConfig", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert remote config value to data"])))
                    return
                }
                Logger.logEvent("Remote Config data: \(data)")
                
                do {
                    // Decode the JSON into FirebaseRemoteConfigModel
                    let configModel = try JSONDecoder().decode(FirebaseRemoteConfigModel.self, from: data)
                    Logger.logEvent("Remote Config decoded: \(configModel)")
                    completion(.success(configModel))
                } catch {
                    Logger.logEvent("Error decoding remote config: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                Logger.logEvent("Remote Config status: \(status)")
                completion(.failure(NSError(domain: "RemoteConfig", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown RemoteConfig status"])))
            }
        }
    }
}
