//
//  APIError.swift
//  NewsApp
//
//  Created by Yermek Sabyrzhan on 26.03.2022.
//

import Foundation

enum APIError: Error {
    case incorrectURL
    case decodingError
    case errorCode(Int)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode the object from the Service"
        case .errorCode(let code):
            return "\(code) - Something went Wrong"
        case .unknown:
            return "Unknown Error"
        case .incorrectURL:
            return "URL creation error"
        }
    }
}
