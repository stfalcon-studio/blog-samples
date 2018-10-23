//
//  ViewController.swift
//  PageControl_project
//
//  Created by Victor Amelin on 7/22/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ViewController: UIViewController {
    
    // MARK: - Outlets 🔌
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    var viewModel: ViewModel!
    
    // MARK: - LifeCycle 🌎
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewBind()
    }
}

// MARK: - Setup 🛠
extension ViewController {
    
    func collectionViewBind() {
        
        // Initialize viewModel
        viewModel = ViewModel()
        
        viewModel.getData()
            
            // Set pageControl.numberOfPages
            // Images should not be nil
            .filter { [unowned self] (images) -> Bool in
                self.pageControl.numberOfPages = images.count
                return images.count > 0
            }
            
            // Bind to collectionView
            // Set pageCtrl.currentPage to selected row
            .bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: Cell.self)) { [unowned self] row, item, cell in
                cell.cellImageView.image = item
                self.pageControl.currentPage = row
            }
            
            // Add .disposed(by: ), when system will call deinit - we`ll get rid of this connection
            .disposed(by: disposeBag)
    }
}
