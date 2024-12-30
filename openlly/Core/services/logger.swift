//
//  logger.swift
//  openlly
//
//  Created by Mobin on 23/12/24.
//

import Foundation

class Logger {
    static func logRequest(_ request: URLRequest) {
        print("\n--- Request ---")
        print("URL: \(request.url?.absoluteString ?? "No URL")")
        print("Method: \(request.httpMethod ?? "No HTTP Method")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "Unable to decode body")")
        }
        print("----------------\n")
    }

    static func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        print("\n--- Response ---")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        if let data = data {
            print("Body: \(String(data: data, encoding: .utf8) ?? "Unable to decode response body")")
        }
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        print("----------------\n")
    }

    static func logEvent(_ message: String) {
        print("\n--- Event ---")
        print(message)
        print("----------------\n")
    }
}
