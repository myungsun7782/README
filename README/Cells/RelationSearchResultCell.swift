//
//  RelationSearchResultCell.swift
//  README
//
//  Created by myungsun on 2023/02/16.
//

import UIKit

class RelationSearchResultCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var resultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(result: String) {
        resultLabel.text = result
        resultLabel.textColor = .black
    }
    
    func addPointLabelColor(result: String) {
        let attributedString = NSMutableAttributedString(string: resultLabel.text!)
        
        attributedString.addAttribute(.foregroundColor, value: ColorManager.shared.getCadmiumGreen(), range: (resultLabel.text! as NSString).range(of: result))
    
        resultLabel.attributedText = attributedString
    }
}
