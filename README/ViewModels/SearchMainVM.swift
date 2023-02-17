//
//  SearchMainVM.swift
//  README
//
//  Created by myungsun on 2023/02/15.
//

import Foundation
import RxSwift

class SearchMainVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variables
    var recommendationArray: [String] = ["상하목장", "기준금리 인상", "오늘의 날씨", "전기차 화재", "중대재해처벌법", "친환경인증"]
    var recentSearchArray: [String] = Array<String>()
    var relationResultArray: [String] = Array<String>()
    var isEnteredData = false
    
    // Constants
    
    // RxSwift
    let disposeBag = DisposeBag()

    struct Input {
        var searchText = BehaviorSubject<String>(value: "")
    }
    
    struct Output {
        var searchDone = PublishSubject<Void>()
        var isEnteredData = BehaviorSubject<Bool>(value: false)
    }
    
    init() {
        input.searchText
            .subscribe(onNext: { changedText in
                self.relationResultArray = []
                self.isEnteredData = changedText.isEmpty ? false : true
                self.output.isEnteredData.onNext(self.isEnteredData)
                
                if !changedText.isEmpty {
                    self.fetchData(searchText: changedText)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchData(searchText: String) {
        NetworkManager.shared.fetchRelationSearch(searchTerm: searchText) { result  in
            switch result {
            case .success(let relationSearchDatas):
                self.relationResultArray = relationSearchDatas
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.output.searchDone.onNext(())
        }
    }
}
