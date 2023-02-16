//
//  ParseManager.swift
//  README
//
//  Created by myungsun on 2023/02/16.
//

import Foundation
import SwiftyJSON

enum SearchKey: String {
    case RESULT = "result"
}

class ParseManager {
    static let shared = ParseManager()
    
    private init() {}
    
    func parseRelationResultJSON(_ resultData: Data) -> [String]? {
        let json = JSON(resultData)
        let relationResult = json[SearchKey.RESULT.rawValue].arrayValue
        var relationResultArray: [String] = Array<String>()
        
        for res in relationResult {
            relationResultArray.append(res.stringValue)
        }
       
        return relationResultArray
    }
}
