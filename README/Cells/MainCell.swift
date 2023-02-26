//
//  MainCell.swift
//  README
//
//  Created by myungsun on 2023/02/26.
//

import UIKit
import RxSwift

class MainCell: UITableViewCell {
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // UIButton
    @IBOutlet weak var searchButton: UIButton!
    
    // Constants
    let BUTTON_IMAGE: UIImage? = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    let VIEW_BORDER_WIDTH: CGFloat = 2
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureContainerView()
        configureButton()
    }
    
    private func configureContainerView() {
        containerView.layer.borderWidth = VIEW_BORDER_WIDTH
        containerView.layer.borderColor = ColorManager.shared.getCadmiumGreen().cgColor
    }
    
    private func configureButton() {
        searchButton.setImage(BUTTON_IMAGE, for: .normal)
    }
}
