//
//  ResultState.swift
//  NewsApp
//
//  Created by Yermek Sabyrzhan on 26.03.2022.
//

import Foundation

enum ResultState {
    case loading
    case success(content: [Article])
    case failed(error: Error)
}
