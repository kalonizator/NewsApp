//
//  EndPoint.swift
//  NewsApp
//
//  Created by Yermek Sabyrzhan on 26.03.2022.
//
import Foundation
import Combine

protocol NetworkManagerProtocol {
    func request<T>(from endpoint: API, object: T.Type) -> AnyPublisher<T, APIError> where T: Decodable, T: Encodable
}

final class NetworkManager: NetworkManagerProtocol {

    public var requestTimeOut: Float = 30

    private func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components
    }

  func request<T: Decodable>(from endpoint: API, object: T.Type) -> AnyPublisher<T, APIError> {
        let components = buildURL(endpoint: endpoint)

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(requestTimeOut)

        guard let url = components.url
        else { return Fail<T, APIError>(error: APIError.incorrectURL).eraseToAnyPublisher() }

        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .mapError { _ in APIError.unknown }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                guard let response = response as? HTTPURLResponse
                else { return Fail<T, APIError>(error: APIError.unknown).eraseToAnyPublisher() }
                switch response.statusCode {
                case 200...299:
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    return Just(data)
                        .decode(type: T.self, decoder: jsonDecoder)
                        .mapError { _ in APIError.decodingError }
                        .eraseToAnyPublisher()
                default:
                    return Fail<T, APIError>(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

}

