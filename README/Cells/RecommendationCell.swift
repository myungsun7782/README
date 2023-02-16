//
//  RecommendationCell.swift
//  README
//
//  Created by myungsun on 2023/02/15.
//

import UIKit

class RecommendationCell: UICollectionViewCell {
    // UILabel
    @IBOutlet weak var titleLabel: UILabel!
    
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // Constants
    let VIEW_BORDER_WIDTH: CGFloat = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderWidth = VIEW_BORDER_WIDTH
        containerView.layer.borderColor = ColorManager.shared.getChineseSilver().cgColor
    }
    
    func setData(title: String) {
        titleLabel.text = title
    }
}
