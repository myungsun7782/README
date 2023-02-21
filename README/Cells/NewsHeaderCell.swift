//
//  NewsHeaderCell.swift
//  README
//
//  Created by myungsun on 2023/02/21.
//

import UIKit

class NewsHeaderCell: UITableViewCell {
    // UIImageView
    @IBOutlet weak var newsImageView: UIImageView!
    
    // UILabel
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Constants
    let TITLE_LINE_SPACING: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    func setData(newsObj: News, category: String) {
        guard let title = newsObj.title else { return }
        guard let date = newsObj.registerData else { return }
        categoryLabel.text = category
        titleLabel.text = title
        dateLabel.text = TimeManager.shared.getRegDataToDateString(regData: date)
    }
    
    func configureLabel() {
        let attrString = NSMutableAttributedString(string: titleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = TITLE_LINE_SPACING
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        titleLabel.attributedText = attrString
    }
}
