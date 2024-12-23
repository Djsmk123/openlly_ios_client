import Foundation
import SwiftUI

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum APIError: Error {
    case invalidResponse
    case noData
    case decodingError
    case unauthorized
    case tokenExpired
    case customError(String)  // New custom error case

}

struct APIResponse<T: Decodable>: Decodable {
    let status: Int
    let success: Bool
    let message: String?
    let data: T?
    let errorCode: String?
    let tokenExpired: Bool?
}

class APIClient {
    private let baseURL: String
    private let session: URLSession
    private let apiVersion: String = "api/v1"

    init(baseURL: String = "https://bull-tight-mongoose.ngrok-free.app/") {
        self.baseURL = baseURL
        self.session = URLSession.shared
    }

    private func getBearerToken() -> String? {
        return UserDefaults.standard.string(forKey: "auth_token")
    }

    func request<T: Decodable>(
        endpoint: String,
        type: RequestType,
        body: Data? = nil,
        contentType: String = "application/json",
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        Logger.logEvent("Initiating \(type.rawValue) request to endpoint: \(endpoint)")

        guard let url = URL(string: "\(baseURL)\(apiVersion)/\(endpoint)") else {
            Logger.logEvent("Invalid URL: \(endpoint)")
            completion(.failure(.invalidResponse))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.allHTTPHeaderFields = [
            "Content-Type": contentType,
            "Authorization": "Bearer \(getBearerToken() ?? "")"
        ]

        if let body = body {
            request.httpBody = body
        }

        Logger.logRequest(request)

        session.dataTask(with: request) { data, response, error in
            Logger.logResponse(data: data, response: response, error: error)

            if let error = error {
                Logger.logEvent("Network error occurred: \(error.localizedDescription)")
                completion(.failure(.invalidResponse))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.logEvent("Invalid response format")
                completion(.failure(.invalidResponse))
                return
            }

            // Handle different HTTP status codes
            if httpResponse.statusCode != 200 {
                Logger.logEvent("HTTP error: \(httpResponse.statusCode)")
                // Try to parse error details from the response body
                if let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode(APIResponse<String>.self, from: data)
                        if let message = errorResponse.message {
                            Logger.logEvent("API Error: \(message)")
                            completion(.failure(.customError(message)))
                        } else {
                            Logger.logEvent("API responded with an unknown error")
                            completion(.failure(.invalidResponse))
                        }
                    } catch {
                        Logger.logEvent("Failed to parse error response body: \(error.localizedDescription)")
                        completion(.failure(.invalidResponse))
                    }
                } else {
                    Logger.logEvent("No data received for HTTP error")
                    completion(.failure(.invalidResponse))
                }
                return
            }

            guard let data = data else {
                Logger.logEvent("No data received from the server")
                completion(.failure(.noData))
                return
            }

            // Check the content type before decoding
            guard let contentType = httpResponse.allHeaderFields["Content-Type"] as? String, contentType.contains("application/json") else {
                Logger.logEvent("Unexpected content type: \(httpResponse.allHeaderFields["Content-Type"] ?? "unknown")")
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let response = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                Logger.logEvent("Decoded response successfully")

                if response.success {
                    if let data = response.data {
                        Logger.logEvent("Request successful")
                        completion(.success(data))
                    } else {
                        Logger.logEvent("No data found in the response")
                        completion(.failure(.noData))
                    }
                } else {
                    // Handle custom error from message
                    if let message = response.message {
                        Logger.logEvent("Custom error received: \(message)")
                        completion(.failure(.customError(message)))
                    } else {
                        Logger.logEvent("API responded with an error: \(response.message ?? "Unknown error")")
                        completion(.failure(.invalidResponse))
                    }
                }
            } catch {
                Logger.logEvent("Decoding error: \(error.localizedDescription)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    private func refreshToken(completion: @escaping (Result<String, APIError>) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else {
            Logger.logEvent("Refresh token not found")
            completion(.failure(.unauthorized))
            return
        }

        let url = URL(string: "\(baseURL)\(apiVersion)/auth/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]

        let body: [String: String] = ["refresh_token": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        Logger.logRequest(request)

        session.dataTask(with: request) { data, response, error in
            Logger.logResponse(data: data, response: response, error: error)

            if let error = error {
                Logger.logEvent("Refresh token request failed: \(error.localizedDescription)")
                completion(.failure(.unauthorized))
                return
            }

            guard let data = data else {
                Logger.logEvent("No data received during refresh token request")
                completion(.failure(.noData))
                return
            }

            do {
                let response = try JSONDecoder().decode(APIResponse<String>.self, from: data)
                if response.success, let newToken = response.data {
                    Logger.logEvent("Token refresh successful")
                    completion(.success(newToken))
                } else {
                    Logger.logEvent("Token refresh failed: \(response.message ?? "Unknown error")")
                    completion(.failure(.unauthorized))
                }
            } catch {
                Logger.logEvent("Decoding error during token refresh: \(error.localizedDescription)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
