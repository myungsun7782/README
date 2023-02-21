//
//  NewsContentCell.swift
//  README
//
//  Created by myungsun on 2023/02/21.
//

import UIKit

class NewsContentCell: UITableViewCell {
    // UITextView
    @IBOutlet weak var contentTextView: UITextView!
    
    // Variables
    var textViewFontSize: CGFloat = 15.3
    
    // Constants
    let TEXT_VIEW_LINE_SPACING: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextView()
    }
    
    func configureTextView() {
        let attrString = NSMutableAttributedString(string: contentTextView.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = TEXT_VIEW_LINE_SPACING
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentTextView.attributedText = attrString
        contentTextView.font = FontManager.shared.getPretendardRegular(fontSize: textViewFontSize)
    }
}
