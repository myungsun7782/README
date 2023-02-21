//
//  SearchResultVM.swift
//  README
//
//  Created by myungsun on 2023/02/17.
//

import Foundation
import RxSwift

class SearchResultVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variables
    var searchResult: String!
    var searchResultArray: [NewsResult] = Array<NewsResult>()
    
    // Constants
    
    // RxSwift
    let disposeBag = DisposeBag()

    struct Input {

    }
    
    struct Output {
        var searchDone = PublishSubject<Void>()
    }
    
    init() {

    }
    
    func fetchData() {
        NetworkManager.shared.fetchSearchResults(searchTerm: searchResult) { result in
            switch result {
            case .success(let newsResultArray):
                self.searchResultArray = newsResultArray
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.output.searchDone.onNext(())
        }
    }
}
