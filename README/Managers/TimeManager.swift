//
//  TimeManager.swift
//  README
//
//  Created by myungsun on 2023/02/17.
//

import Foundation

class TimeManager {
    static let shared = TimeManager()
    
    private init() {}
    
    func getRegDataToDateString(regData: Int) -> String{
        var regDataString: String = String(regData)
        
        let monthRange = regDataString.index(regDataString.startIndex, offsetBy: 4) ... regDataString.index(regDataString.startIndex, offsetBy: 5)
        let dayRange = regDataString.index(regDataString.startIndex, offsetBy: 6) ... regDataString.index(regDataString.startIndex, offsetBy: 7)
        
        let year = regDataString.prefix(4)
        let month = regDataString[monthRange]
        let day = regDataString[dayRange]
        
        return year + ". " + month + ". " + day
    }
}
