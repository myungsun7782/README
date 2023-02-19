//
//  SearchResultCell.swift
//  README
//
//  Created by myungsun on 2023/02/17.
//

import UIKit

class SearchResultCell: UITableViewCell {
    // UILabel
    @IBOutlet var titleLabelArray: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var associatedNewsLabel: UILabel!
    
    // UIStackView
    @IBOutlet var newsStackViewArray: [UIStackView]!
    @IBOutlet weak var associatedNewsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(newsResult: NewsResult) {
        guard let newsList = newsResult.newsList else { return }
        guard let category = newsResult.category else { return }
        guard let firstTitle = newsList[0].title else { return }
        
        guard let firstRegData = newsList[0].registerData else { return }
        titleLabelArray[0].text = firstTitle
        dateLabel.text = TimeManager.shared.getRegDataToDateString(regData: firstRegData)
        categoryLabel.text = category
        
        switch newsList.count {
        case 1:
            associatedNewsStackView.isHidden = true
            for idx in 1...4 {
                newsStackViewArray[idx].isHidden = true
            }
            
        case 2:
            newsStackViewArray[1].isHidden = false
            associatedNewsStackView.isHidden = true
            for idx in 2...4 {
                newsStackViewArray[idx].isHidden = true
            }
            guard let title = newsList[1].title else { return }
            titleLabelArray[1].text = title
        case 3:
            associatedNewsStackView.isHidden = true
            for idx in 3...4 {
                newsStackViewArray[idx].isHidden = true
            }
            
            for idx in 1...2 {
                newsStackViewArray[idx].isHidden = false
                guard let title = newsList[idx].title else { return }
                titleLabelArray[idx].text = title
            }
        case 4:
            associatedNewsStackView.isHidden = true
            newsStackViewArray[4].isHidden = true
            
            for idx in 1...3 {
                newsStackViewArray[idx].isHidden = false
                guard let title = newsList[idx].title else { return }
                titleLabelArray[idx].text = title
            }
            
        case 5:
            associatedNewsStackView.isHidden = true
            
            for idx in 1...4 {
                newsStackViewArray[idx].isHidden = false
                guard let title = newsList[idx].title else { return }
                titleLabelArray[idx].text = title
            }
        default:
            associatedNewsStackView.isHidden = false
            associatedNewsLabel.text = "관련뉴스 \(newsList.count - 5)건 전체보기"
            
            for idx in 1...4 {
                newsStackViewArray[idx].isHidden = false
                guard let title = newsList[idx].title else { return }
                titleLabelArray[idx].text = title
            }
        }
    }
}
