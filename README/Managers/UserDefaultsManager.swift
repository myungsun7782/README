//
//  UserDefaultsManager.swift
//  README
//
//  Created by myungsun on 2023/02/21.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let RECENT_SEARCH_LIST = "recentSearchList"
    
    private init() {}
    
    func getRecentSearchList() -> [String] {
        return UserDefaults.standard.object(forKey: RECENT_SEARCH_LIST) as? [String] ?? []
    }
    
    func setRecentSearchList(recentSearchList: [String]) {
        UserDefaults.standard.set(recentSearchList, forKey: RECENT_SEARCH_LIST)
    }
    
    func saveRecentSearchList(searchTerm: String) {
        var recentSearchArray: [String] = getRecentSearchList()
        recentSearchArray.insert(searchTerm, at: recentSearchArray.startIndex)
        setRecentSearchList(recentSearchList: recentSearchArray)
    }
}
