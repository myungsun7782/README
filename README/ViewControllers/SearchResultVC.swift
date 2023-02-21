//
//  SearchResultVC.swift
//  README
//
//  Created by myungsun on 2023/02/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class SearchResultVC: UIViewController {
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // UILabel
    @IBOutlet weak var resultLabel: UILabel!
    
    // UITableView
    @IBOutlet weak var searchResultTableView: UITableView!
    
    // UIStackView
    @IBOutlet weak var resultStackView: UIStackView!
    
    // NSLayoutConstraint
    @IBOutlet weak var dynamicViewHeight: NSLayoutConstraint!
    
    // ViewModel
    let viewModel = SearchResultVM()
    
    // Variables
    
    // Constants
    let CONTAINER_VIEW_TARGET_HEIGHT: CGFloat = 0
    let VIEW_DECREASE_NUMBER: CGFloat = 0.001
    let ANIMATION_DELAY_TIME: CGFloat = 0.2
    let ANIMATION_DURATION: TimeInterval = 0.5
    let ANIMATION_DELAY: TimeInterval = 0.1
    let BUTTON_IMAGE: UIImage? = UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
        delayViewAnimation()
        viewModel.fetchData()
        LoadingManager.shared.showLoading()
    }

    private func initUI() {
        // UITableView
        configureTableView()
        
        // UIButton
        configureButton()
        
        // UIStackView
        resultStackView.alpha = .zero
        
        // UILabel
        resultLabel.text = viewModel.searchResult
    }
    
    private func action() {
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        viewModel.output.searchDone
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    LoadingManager.shared.hideLoading()
                    self.searchResultTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        backButton.alpha = .zero
        backButton.setImage(BUTTON_IMAGE, for: .normal)
    }
    
    private func configureTableView() {
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        searchResultTableView.register(UINib(nibName: Cell.searchResultCell, bundle: nil), forCellReuseIdentifier: Cell.searchResultCell)
    }
    
    private func animateContainerView(duration: TimeInterval, delay: TimeInterval) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut) {
            while self.dynamicViewHeight.constant >= self.CONTAINER_VIEW_TARGET_HEIGHT {
                if self.dynamicViewHeight.constant == self.CONTAINER_VIEW_TARGET_HEIGHT {
                    break
                }
                self.dynamicViewHeight.constant -= self.VIEW_DECREASE_NUMBER
            }
            self.backButton.alpha = 1
            self.resultStackView.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { _ in
        }
    }
    
    private func delayViewAnimation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.ANIMATION_DELAY_TIME) {
            self.animateContainerView(duration: self.ANIMATION_DURATION, delay: self.ANIMATION_DELAY)
        }
    }
    
    private func presentDetailNewsVC(newsObj: News, category: String) {
        let detailNewsVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.detailNewsVC) as! DetailNewsVC
        
        detailNewsVC.viewModel.news = newsObj
        detailNewsVC.viewModel.category = category
        detailNewsVC.modalTransitionStyle = .crossDissolve
        detailNewsVC.modalPresentationStyle = .overFullScreen
        
        present(detailNewsVC, animated: true)
    }
}

extension SearchResultVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.searchResultCell, for: indexPath) as! SearchResultCell
        
        cell.setData(newsResult: viewModel.searchResultArray[indexPath.row], keyWord: resultLabel.text!)
        
        for (idx, _) in cell.titleLabelArray.enumerated() {
            cell.titleLabelArray[idx].rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    let index = tableView.indexPath(for: cell)!.row
                    self.presentDetailNewsVC(newsObj: self.viewModel.searchResultArray[index].newsList![idx], category: self.viewModel.searchResultArray[index].category!)
                })
                .disposed(by: disposeBag)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
