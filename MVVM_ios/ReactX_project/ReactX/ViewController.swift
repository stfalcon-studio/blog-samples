//
//  ViewController.swift
//  ReactX
//
//  Created by Victor Amelin on 7/5/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import Moya
import Moya_ModelMapper
import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<GitHub>!
    var latestRepositoryName: Observable<String> {
        return searchBar
            .rx_text
            .filter { $0.characters.count > 2 }
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    var issueTrackerModel: IssueTrackerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        provider = RxMoyaProvider<GitHub>()
        
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
        
        issueTrackerModel
            .trackIssues()
            .bindTo(tableView.rx_itemsWithCellFactory) { (tableView, row, item) in
                print(item)
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
                cell!.textLabel?.text = item.title
                
                return cell!
            }
            .addDisposableTo(disposeBag)
        
        //if tableView item is selected - deselect it)
        tableView
            .rx_itemSelected
            .subscribeNext { indexPath in
                if self.searchBar.isFirstResponder() == true {
                    self.view.endEditing(true)
                }
            }.addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

















