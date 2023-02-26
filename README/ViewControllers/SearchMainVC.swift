//
//  SearchMainVC.swift
//  README
//
//  Created by myungsun on 2023/02/15.
//

import UIKit
import RxSwift
import RxCocoa

class SearchMainVC: UIViewController {
    // UITextField
    @IBOutlet weak var searchTextField: UITextField!
    
    // UIButton
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // UIView
    @IBOutlet weak var lineView: UIView!
    
    // UIStackView
    @IBOutlet weak var recommendationStackView: UIStackView!
    
    // UITableView
    @IBOutlet weak var searchTableView: UITableView!
    
    // UICollectionView
    @IBOutlet weak var recommendationCollectionView: UICollectionView!
    
    // NSLayoutConstraint
    @IBOutlet weak var dynamicLineViewHeight: NSLayoutConstraint!
    
    // ViewModel
    let viewModel = SearchMainVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Constants
    let LABEL_FONT_SIZE: CGFloat = 14
    let COLLECTION_VIEW_CELL_HEIGHT: CGFloat = 35
    let COLLECTION_VIEW_CELL_WIDTH_WEIGHT: CGFloat = 30
    let TEXT_FIELD_PLACE_HOLDER: String = "뉴스 검색어를 입력해주세요 :)"
    let TEXT_FIELD_FONT_SIZE: CGFloat = 20.71
    let SEARCH_BUTTON_IMAGE: UIImage? = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    let LINE_VIEW_TARGET_HEIGHT: CGFloat = 80
    let LINE_INCREASE_NUMBER: CGFloat = 0.001
    let ANIMATION_DURATION: TimeInterval = 0.5
    let ANIMATION_DELAY: TimeInterval = 0.1
    let COLLECTION_VIEW_MINIMUM_SPACING: CGFloat = 13
    let ALERT_TITLE: String = "메시지"
    let ALERT_MESSAGE: String = "검색어는 1글자 이상 입력해주세요 :)"
    let ALERT_BUTTON_TITLE: String = "확인"
    let BACK_BUTTON_IMAGE: UIImage? = UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        searchTextField.becomeFirstResponder()
        viewModel.recentSearchArray = UserDefaultsManager.shared.getRecentSearchList()
        searchTableView.reloadData()
    }
    
    private func initUI() {
        // UITextField
        configureTextField()
        
        // UIButton
        configureButton()
        
        // UICollectionView
        configureCollectionView()
        
        // UITableView
        configureTableView()
    }
    
    private func action() {
        // UITextField
        searchTextField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { _ in
                self.animateLineView(duration: self.ANIMATION_DURATION, delay: self.ANIMATION_DELAY)
                DispatchQueue.main.async {
                    self.lineView.backgroundColor = ColorManager.shared.getWhite()
                    self.searchButton.tintColor = ColorManager.shared.getWhite()
                    self.searchTextField.textColor = ColorManager.shared.getWhite()
                }
            })
            .disposed(by: disposeBag)
        
        // UIButton
        searchButton.rx.tap
            .subscribe(onNext: { _ in
                if self.searchTextField.text!.isEmpty {
                    self.presentAlert()
                } else {
                    self.presentSearchResultVC()
                }
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        // Input
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.output.searchDone
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isEnteredData
            .subscribe(onNext: { isEnteredData in
                self.recommendationStackView.isHidden = isEnteredData ? true : false
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTextField() {
        searchTextField.font = FontManager.shared.getPretendardRegular(fontSize: TEXT_FIELD_FONT_SIZE)
        searchTextField.attributedPlaceholder = NSAttributedString(string: TEXT_FIELD_PLACE_HOLDER, attributes: [NSAttributedString.Key.foregroundColor : ColorManager.shared.getGray()])
    }
    
    private func configureButton() {
        searchButton.setImage(SEARCH_BUTTON_IMAGE, for: .normal)
        backButton.setImage(BACK_BUTTON_IMAGE, for: .normal)
    }
    
    private func configureCollectionView() {
        recommendationCollectionView.dataSource = self
        recommendationCollectionView.delegate = self
        recommendationCollectionView.register(UINib(nibName: Cell.recommendationCell, bundle: nil), forCellWithReuseIdentifier: Cell.recommendationCell)
    }
    
    private func configureTableView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        tap.cancelsTouchesInView = false
        searchTableView.addGestureRecognizer(tap)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: Cell.relationSearchResultCell, bundle: nil), forCellReuseIdentifier: Cell.relationSearchResultCell)
        searchTableView.register(UINib(nibName: Cell.recentSearchCell, bundle: nil), forCellReuseIdentifier: Cell.recentSearchCell)
    }
    
    private func animateLineView(duration: TimeInterval, delay: TimeInterval) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut) {
            var height: CGFloat = 0
            while height <= self.LINE_VIEW_TARGET_HEIGHT {
                if self.dynamicLineViewHeight.constant == self.LINE_VIEW_TARGET_HEIGHT {
                    break
                }
                self.dynamicLineViewHeight.constant = height
                height += self.LINE_INCREASE_NUMBER
            }
            self.view.layoutIfNeeded()
        } completion: { _ in }
    }
    
    private func presentSearchResultVC() {
        let searchResultVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.searchResultVC) as! SearchResultVC
        
        searchResultVC.viewModel.searchResult = searchTextField.text
        UserDefaultsManager.shared.saveRecentSearchList(searchTerm: searchTextField.text!)
        searchResultVC.modalTransitionStyle = .crossDissolve
        searchResultVC.modalPresentationStyle = .fullScreen
        resetTextField()
        
        present(searchResultVC, animated: true)
    }
    
    private func resetTextField() {
        searchTextField.text = ""
        viewModel.relationResultArray = []
        searchTableView.reloadData()
        view.endEditing(true)
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: ALERT_TITLE, message: ALERT_MESSAGE, preferredStyle: .alert)
        let checkButton = UIAlertAction(title: ALERT_BUTTON_TITLE, style: .default)
        
        alert.addAction(checkButton)
        self.present(alert, animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // 유저가 화면을 터치했을 때 호출되는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 키보드를 내린다.
        self.view.endEditing(true)
    }
}

extension SearchMainVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recommendationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.recommendationCell, for: indexPath) as! RecommendationCell
        
        cell.setData(title: viewModel.recommendationArray[indexPath.row])
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewModel.recommendationArray[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : FontManager.shared.getPretendardRegular(fontSize: LABEL_FONT_SIZE)]).width + COLLECTION_VIEW_CELL_WIDTH_WEIGHT, height: COLLECTION_VIEW_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return COLLECTION_VIEW_MINIMUM_SPACING
    }
}

extension SearchMainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isEnteredData ? viewModel.relationResultArray.count : viewModel.recentSearchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isEnteredData {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.relationSearchResultCell, for: indexPath) as! RelationSearchResultCell
            
            if indexPath.row >= 0 && indexPath.row <= viewModel.relationResultArray.count {
                cell.setData(result: viewModel.relationResultArray[indexPath.row])
            }
        
            cell.addPointLabelColor(result: searchTextField.text ?? "")
            cell.selectionStyle = .none
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.recentSearchCell, for: indexPath) as! RecentSearchCell
        
        cell.setData(recentSearchTerm: viewModel.recentSearchArray[indexPath.row])
        cell.deleteButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.recentSearchArray.remove(at: indexPath.row)
                UserDefaultsManager.shared.setRecentSearchList(recentSearchList: self.viewModel.recentSearchArray)
                self.searchTableView.reloadData()
            })
            .disposed(by: cell.disposeBag)
        
        cell.selectionStyle = .none
        
        return cell
    }
}
