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

class ViewController: UIViewController {

    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var collView: UICollectionView!
    
    let disposeBag = DisposeBag()
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        
        //initialize viewModel
        viewModel = ViewModel()
        
        viewModel.getData()
            //set pageCtr.numberOfPages
            //images should not be nil
            .filter { [unowned self] (images) -> Bool in
                self.pageCtrl.numberOfPages = images.count
                return images.count > 0
            }
            
            //bind to collectionView
            //set pageCtrl.currentPage to selected row
            .bindTo(collView.rx_itemsWithCellIdentifier("Cell", cellType: Cell.self)) { [unowned self] (row, element, cell) in
                cell.cellImageView.image = element
                self.pageCtrl.currentPage = row
            }
            
            //add to disposeableBag, when system will call deinit - we`ll get rid of this connection
            .addDisposableTo(disposeBag)
    }
}









