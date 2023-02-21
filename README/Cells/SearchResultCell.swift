//
//  SearchResultCell.swift
//  README
//
//  Created by myungsun on 2023/02/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class SearchResultCell: UITableViewCell {
    // UILabel
    @IBOutlet var titleLabelArray: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var associatedNewsLabel: UILabel!
    
    // UIStackView
    @IBOutlet var newsStackViewArray: [UIStackView]!
    @IBOutlet weak var associatedNewsStackView: UIStackView!
    @IBOutlet weak var entireStackView: UIStackView!
    
    // Constants
    let ENTIRE_STACK_VIEW_MAIN_SPACING: CGFloat = 20
    let ENTIRE_STACK_VIEW_SUB_SPACING: CGFloat = 10
    let LABEL_LINE_SPACING: CGFloat = 1
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setParagraphStyle()
    }
    
    func setData(newsResult: NewsResult, keyWord: String) {
        guard let newsList = newsResult.newsList else { return }
        guard let category = newsResult.category else { return }
        guard let firstTitle = newsList[0].title else { return }
        
        guard let firstRegData = newsList[0].registerData else { return }
        titleLabelArray[0].text = firstTitle
        titleLabelArray[0].textColor = .black
        addPointLabelColor(result: keyWord, titleLabel: titleLabelArray[0])
        dateLabel.text = TimeManager.shared.getRegDataToDateString(regData: firstRegData)
        categoryLabel.text = category
        entireStackView.spacing = ENTIRE_STACK_VIEW_MAIN_SPACING
        
        switch newsList.count {
        case 1:
            associatedNewsStackView.isHidden = true
            entireStackView.spacing = ENTIRE_STACK_VIEW_SUB_SPACING
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
            titleLabelArray[1].textColor = .black
            addPointLabelColor(result: keyWord, titleLabel: titleLabelArray[1])
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
                titleLabelArray[idx].textColor = .black
                addPointLabelColor(result: keyWord, titleLabel: titleLabelArray[idx])
            }
        case 5:
            associatedNewsStackView.isHidden = true
            
            for idx in 1...4 {
                newsStackViewArray[idx].isHidden = false
                guard let title = newsList[idx].title else { return }
                titleLabelArray[idx].text = title
                titleLabelArray[idx].textColor = .black
                addPointLabelColor(result: keyWord, titleLabel: titleLabelArray[idx])
            }
        default:
            associatedNewsStackView.isHidden = false
            associatedNewsLabel.text = "관련뉴스 \(newsList.count - 5)건 전체보기"
            
            for idx in 1...4 {
                newsStackViewArray[idx].isHidden = false
                guard let title = newsList[idx].title else { return }
                titleLabelArray[idx].text = title
                titleLabelArray[idx].textColor = .black
                addPointLabelColor(result: keyWord, titleLabel: titleLabelArray[idx])
            }
        }
    }
    
    func setParagraphStyle() {
        let attrString = NSMutableAttributedString(string: titleLabelArray[0].text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = LABEL_LINE_SPACING
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        titleLabelArray[0].attributedText = attrString
        titleLabelArray[0].translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addPointLabelColor(result: String, titleLabel: UILabel) {
        let attributedString = NSMutableAttributedString(string: titleLabel.text!)
        
        attributedString.addAttribute(.foregroundColor, value: ColorManager.shared.getCadmiumGreen(), range: (titleLabel.text! as NSString).range(of: result))
        

        titleLabel.attributedText = attributedString
    }
}
