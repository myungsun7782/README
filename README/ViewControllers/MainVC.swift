//
//  ViewController.swift
//  README
//
//  Created by myungsun on 2023/02/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MainVC: UIViewController {
    // UITableView
    @IBOutlet weak var mainTableView: UITableView!
    
    // Constants
    let NUMBER_OF_ROW_IN_SECTION: Int = 1
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        // UITableView
        configureTableView()
    }
    
    private func configureTableView() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(UINib(nibName: Cell.mainCell, bundle: nil), forCellReuseIdentifier: Cell.mainCell)
    }
    
    private func presentSearchMainVC() {
        let searchMainVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.searchMainVC) as! SearchMainVC
        
        searchMainVC.modalPresentationStyle = .fullScreen
        searchMainVC.modalTransitionStyle = .crossDissolve
        
        present(searchMainVC, animated: true)
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROW_IN_SECTION
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.mainCell, for: indexPath) as! MainCell
        
        cell.selectionStyle = .none
        cell.containerView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.presentSearchMainVC()
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

