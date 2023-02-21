//
//  DetailNewsVC.swift
//  README
//
//  Created by myungsun on 2023/02/20.
//

import UIKit
import RxSwift
import RxCocoa

class DetailNewsVC: UIViewController {
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sizeConfigurationButton: UIButton!
    @IBOutlet var buttonArray: [UIButton]!
    
    // UIStackView
    @IBOutlet weak var entireStackView: UIStackView!
    @IBOutlet weak var configurationStackView: UIStackView!
    
    // UITableView
    @IBOutlet weak var detailNewsTableView: UITableView!
    
    // UITableViewCell
    var newsContentCell: NewsContentCell?
    
    // ViewModel
    let viewModel = DetailNewsVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Constants
    let BUTTON_BORDER_WIDTH: CGFloat = 1
    let NUMBER_OF_TABLE_VIEW_SECTION: Int = 2
    let NUMBER_OF_ROW_IN_SECTION: Int = 1
    let BUTTON_IMAGE: UIImage? = UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
    }
    
    private func initUI() {
        // UIButton
        configureButton()
        
        // UITableView
        configureTableView()
    }
    
    private func action() {
        // UIButton
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        sizeConfigurationButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.isClicked = !self.viewModel.isClicked
                self.viewModel.output.isClicked.onNext(self.viewModel.isClicked)
            })
            .disposed(by: disposeBag)
        
        buttonArray.forEach { button in
            button.rx.tap
                .subscribe(onNext: { _ in
                    self.viewModel.isClickedArray = [false, false, false, false, false]
                    self.viewModel.isClickedArray[button.tag] = true
                    self.viewModel.output.isClckedArray.onNext(self.viewModel.isClickedArray)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func bind() {
        // Output
        viewModel.output.isClicked
            .subscribe(onNext: { isClicked in
                self.configurationStackView.isHidden = isClicked ? false : true
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isClckedArray
            .subscribe(onNext: { isClickedArray in
                guard let idx = isClickedArray.firstIndex(of: true) else { return }
                self.buttonArray.forEach { button in
                    button.backgroundColor = ColorManager.shared.getWhite()
                }
                self.buttonArray[idx].backgroundColor = ColorManager.shared.getPastelGray()
                self.adjustContentFontSize(idx: idx)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        backButton.setImage(BUTTON_IMAGE, for: .normal)
        for (idx, _) in buttonArray.enumerated() {
            buttonArray[idx].layer.borderWidth = BUTTON_BORDER_WIDTH
            buttonArray[idx].layer.borderColor = ColorManager.shared.getArgent().cgColor
            buttonArray[idx].layer.cornerRadius = buttonArray[idx].bounds.height / 2
        }
    }
    
    private func configureTableView() {
        detailNewsTableView.dataSource = self
        detailNewsTableView.delegate = self
        detailNewsTableView.register(UINib(nibName: Cell.newsHeaderCell, bundle: nil), forCellReuseIdentifier: Cell.newsHeaderCell)
        detailNewsTableView.register(UINib(nibName: Cell.newsContentCell, bundle: nil), forCellReuseIdentifier: Cell.newsContentCell)
    }
    
    private func adjustContentFontSize(idx: Int) {
        guard let cell = newsContentCell else { return }
        switch idx {
        case 0:
            cell.textViewFontSize = 11.9
        case 1:
            cell.textViewFontSize = 13.6
        case 2:
            cell.textViewFontSize = 15.3
        case 3:
            cell.textViewFontSize = 17
        case 4:
            cell.textViewFontSize = 18.68
        default:
            break
        }
        cell.configureTextView()
        detailNewsTableView.reloadData()
    }
}

extension DetailNewsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_TABLE_VIEW_SECTION
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROW_IN_SECTION
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.newsHeaderCell, for: indexPath) as! NewsHeaderCell
            
            cell.setData(newsObj: viewModel.news, category: viewModel.category)
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.newsContentCell, for: indexPath) as! NewsContentCell
            newsContentCell = cell
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
}
