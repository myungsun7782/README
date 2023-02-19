//
//  NetworkManager.swift
//  README
//
//  Created by myungsun on 2023/02/16.
//

import Foundation
import SwiftyJSON

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    typealias RelationSearchCompletion = (Result<[String], NetworkError>) -> Void
    typealias SearchResultCompletion = (Result<[NewsResult], NetworkError>) -> Void
    
    func fetchRelationSearch(searchTerm: String, completionHandler: @escaping RelationSearchCompletion) {
        let urlString = "\(SearchApi.requestUrl)\(SearchApi.relationSearchParam)\(searchTerm)"
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        performRequest(with: encodedStr) { result in
            completionHandler(result)
        }
    }
    
    func fetchSearchResults(searchTerm: String, completionHandler: @escaping SearchResultCompletion) {
        let urlString = "\(SearchApi.requestUrl)\(SearchApi.searchParam)\(searchTerm)"
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        performSearchRequest(with: encodedStr) { result in
            completionHandler(result)
        }
    }
    
    private func performRequest(with urlString: String, completionHandler: @escaping RelationSearchCompletion) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completionHandler(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            if let recentResultArray = ParseManager.shared.parseRelationResultJSON(safeData) {
                completionHandler(.success(recentResultArray))
            } else {
                print("Parse 실패")
                completionHandler(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    private func performSearchRequest(with urlString: String, completionHandler: @escaping SearchResultCompletion) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completionHandler(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            if let searchResultArray = ParseManager.shared.parseSearchResultJSON(safeData) {
                completionHandler(.success(searchResultArray))
            } else {
                print("Parse 실패")
                completionHandler(.failure(.parseError))
            }
        }
        task.resume()
    }
}
