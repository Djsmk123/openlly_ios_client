import Foundation
import SwiftUI
import Network

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
    case customError(String)  // New custom error cause
    case noInternetConnection   
}

struct APIResponse<T: Decodable>: Decodable {
    let status: Int
    let success: Bool
    let message: String?
    let data: T?
    let errorCode: String?
    let tokenExpired: Bool?
}
struct VoidResponse: Decodable {
    
}

class APIClient {
    private let baseURL: String
    private let session: URLSession
    private let apiVersion: String = "/api/v1"
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = false
    private var remoteService = FirebaseRemoteService.shared

    init() {
        self.baseURL = remoteService.remoteConfigModel?.apiBaseUrl ?? ""
        
        self.session = URLSession.shared
        startNetworkMonitoring()
    }

    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        monitor.start(queue: queue)
    }

    private func getBearerToken() -> String? {
        return UserDefaults.standard.string(forKey: "auth_token")
    }

    func isConnectedToInternet() -> Bool {
        return isConnected
    }

    func request<T: Decodable>(
        endpoint: String,
        type: RequestType,
        body: Data? = nil,
        contentType: String = "application/json",
        isMultipart: Bool = false,
        formData: [String: Any]? = nil,
        fileData: [String: Data]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        Logger.logEvent("Initiating \(type.rawValue) request to endpoint: \(endpoint)")

        guard isConnectedToInternet() else {
            Logger.logEvent("No internet connection")
            completion(.failure(.noInternetConnection))
            return
        }

        guard let url = URL(string: "\(baseURL)\(apiVersion)/\(endpoint)") else {
            Logger.logEvent("Invalid URL: \(endpoint)")
            completion(.failure(.invalidResponse))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(getBearerToken() ?? "")"
        ]

        if isMultipart, let formData = formData {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createMultipartBody(with: formData, fileData: fileData, boundary: boundary)
        } else if contentType == "application/x-www-form-urlencoded", let formData = formData {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = createFormURLEncodedBody(with: formData)
        } else if let body = body {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
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

            if httpResponse.statusCode != 200 {
                self.handleHTTPError(response: httpResponse, data: data, completion: completion)
                return
            }

            guard let data = data else {
                Logger.logEvent("No data received from the server")
                completion(.failure(.noData))
                return
            }

            do {
                if T.self == VoidResponse.self {
                    completion(.success(VoidResponse() as! T))
                    return
                }

                let decodedResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                if decodedResponse.success {
                    if let responseData = decodedResponse.data {
                        completion(.success(responseData))
                    } else {
                        completion(.failure(.noData))
                    }
                } else {
                    let errorMessage = decodedResponse.message ?? "Unknown error"
                    completion(.failure(.customError(errorMessage)))
                }
            } catch {
                Logger.logEvent("Decoding error: \(error.localizedDescription)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    private func createMultipartBody(
        with parameters: [String: Any],
        fileData: [String: Data]?,
        boundary: String
    ) -> Data {
        var body = Data()

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        if let fileData = fileData {
            for (key, data) in fileData {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    private func createFormURLEncodedBody(with parameters: [String: Any]) -> Data? {
        let encodedParams = parameters.map { key, value in
            "\(key)=\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }.joined(separator: "&")
        return encodedParams.data(using: .utf8)
    }

    private func handleHTTPError<T: Decodable>(
        response: HTTPURLResponse,
        data: Data?,
        completion: (Result<T, APIError>) -> Void
    ) {
        if let data = data {
            do {
                let errorResponse = try JSONDecoder().decode(APIResponse<String>.self, from: data)
                let errorMessage = errorResponse.message ?? "HTTP Error: \(response.statusCode)"
                completion(.failure(.customError(errorMessage)))
            } catch {
                completion(.failure(.invalidResponse))
            }
        } else {
            completion(.failure(.invalidResponse))
        }
    }
}
