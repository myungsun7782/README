//
//  DetailNewsVM.swift
//  README
//
//  Created by myungsun on 2023/02/21.
//

import Foundation
import RxSwift

class DetailNewsVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variables
    var news: News!
    var category: String!
    var isClicked: Bool = false
    var isClickedArray: [Bool] = [false, false, true, false, false]
    
    // Constants
    
    // RxSwift
    let disposeBag = DisposeBag()

    struct Input {
        
    }
    
    struct Output {
        var isClicked = BehaviorSubject<Bool>(value: false)
        var isClckedArray = BehaviorSubject<[Bool]>(value: [false, false, true, false, false])
    }
    
    init() {

    }
}
