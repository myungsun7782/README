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
    static let searchResultCell = "SearchResultCell"
    static let newsHeaderCell = "NewsHeaderCell"
    static let newsContentCell = "NewsContentCell"
    static let mainCell = "MainCell"
}

public enum SearchApi {
    static let requestUrl = "http://loopy-lim.com:3100/"
    static let relationSearchParam = "search?word="
    static let searchParam = "?query="
}

public enum VC {
    static let searchMainVC = "SearchMainVC"
    static let searchResultVC = "SearchResultVC"
    static let detailNewsVC = "DetailNewsVC"
}

public enum Storyboard {
    static let main = "Main"
}
