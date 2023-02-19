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
    case CATEGORY = "category"
    case TOTAL = "total"
    case NEWS_LIST = "newsList"
    case TITLE = "title"
    case REG_DATA = "reg_data"
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
    
    func parseSearchResultJSON(_ resultData: Data) -> [NewsResult]? {
        let jsonArray = JSON(resultData).arrayValue
        
        var newsResultArray: [NewsResult] = Array<NewsResult>()
        
        for obj in jsonArray {
            var newsList: [News] = Array<News>()
            if obj[SearchKey.TOTAL.rawValue].intValue == 0 {
                continue
            }
            
            for news in obj[SearchKey.NEWS_LIST.rawValue].arrayValue {
                let title = news[SearchKey.TITLE.rawValue].stringValue
                let regData = news[SearchKey.REG_DATA.rawValue].intValue
            
                newsList.append(News(title: title, registerData: regData))
            }
            let newsResult = NewsResult(category: obj[SearchKey.CATEGORY.rawValue].stringValue, total: obj[SearchKey.TOTAL.rawValue].intValue, newsList: newsList)
            newsResultArray.append(newsResult)
        }
        return newsResultArray
    }
}
