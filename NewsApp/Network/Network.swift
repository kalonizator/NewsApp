//
//  EndPoint.swift
//  NewsApp
//
//  Created by Yermek Sabyrzhan on 26.03.2022.
//

import UIKit
import Foundation

final class NetworkManager {
    
    private class func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components
    }

    class func request<T: Decodable>(endpoint: API,
                                     completion: @escaping (Result<T, Error>)
                                     -> Void) {
        let components = buildURL(endpoint: endpoint)
        guard let url = components.url else {
            print("URL creation error")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) {
            data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Unknown error", error)
                return
            }
            guard response != nil, let data = data else {
                return
            }
            if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(responseObject))
            } else {
                let error = NSError(domain: "com.tisobyn",
                                    code: 200,
                                    userInfo: [
                                        NSLocalizedDescriptionKey: "Failed"
                                    ])
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}



final class TableVC: UITableViewController {
    let query = "query"
    let latitude = 000
    let longitude = 000


    func getGooglePlaces() {
        let endpoint = NewsAPI.getArticles
        NetworkManager.request(endpoint: endpoint) { [weak self]
                        (result: Result<NewsResponse, Error>) in
                        switch result {
                        case .success(let response):
//                            self?.dataSource = response.results
//                            self?.tableView.reloadData()
                        case .failure(let error):
                            Log.error(error)
                        }
        }
    }

    func setImage() {
        //        thumbnailImageView.loadImageFromURL(urlString: photoURL)
    }
}
