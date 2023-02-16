//
//  Constants.swift
//  README
//
//  Created by myungsun on 2023/02/16.
//

import Foundation

public enum Cell {
    // UICollectionView
    static let recommendationCell = "RecommendationCell"
    
    // UITableView
    static let relationSearchResultCell = "RelationSearchResultCell"
    static let recentSearchCell = "RecentSearchCell"
}

public enum SearchApi {
    static let requestUrl = "http://loopy-lim.com:3100/"
    static let relationSearchParam = "search?word="
    static let searchParam = "?query="
}

public enum VC {
    
}

public enum Storyboard {
    static let main = "Main"
}
