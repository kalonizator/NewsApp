//
//  NewsApi.swift
//  NewsApp
//
//  Created by Yermek Sabyrzhan on 26.03.2022.
//

import UIKit
import Foundation

// URL is = https://api.lil.software/news

enum NewsAPI: API {
    case getArticles

    var scheme: HTTPScheme {
        switch self {
        case .getArticles:
            return .https
        }
    }

    var baseURL: String {
        switch self {
        case .getArticles:
            return "api.lil.software"
        }
    }

    var path: String {
        switch self {
        case .getArticles:
            return "/news"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .getArticles:
            return []
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getArticles:
            return .get
        }
    }

}

