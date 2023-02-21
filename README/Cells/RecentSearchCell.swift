//
//  RecentSearchCell.swift
//  README
//
//  Created by myungsun on 2023/02/16.
//

import UIKit
import RxSwift
import RxCocoa

class RecentSearchCell: UITableViewCell {
    // UILabel
    @IBOutlet weak var recentSearchLabel: UILabel!
    
    // UIButton
    @IBOutlet weak var deleteButton: UIButton!
    
    // RxSwift
    // 외부에서 읽기만 가능하고 내부에서만 수정이 가능하도록 하는 코드
    private(set) var disposeBag = DisposeBag()
    
    // Constants
    let BUTTON_IMAGE: UIImage? = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.setImage(BUTTON_IMAGE, for: .normal)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    
    func setData(recentSearchTerm: String) {
        recentSearchLabel.text = recentSearchTerm
    }
}
