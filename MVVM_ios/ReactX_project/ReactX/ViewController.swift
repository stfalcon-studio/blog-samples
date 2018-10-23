//
//  ViewController.swift
//  ReactX
//
//  Created by Victor Amelin on 7/5/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa


final class ViewController: UIViewController {
    
    // MARK: - Outlets 🔌
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var provider: MoyaProvider<GitHub>!
    var issueTrackerModel: IssueTrackerModel!
    
    
    var latestRepositoryName: Observable<String> {
        return searchBar.rx
            .text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    // MARK: - LifeCycle 🌍
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewBind()
    }
}

private extension ViewController {
    func tableViewBind() {
        
        // First part of the puzzle, create our Provider
        provider = MoyaProvider<GitHub>(plugins: [NetworkLoggerPlugin(verbose: true)])
        
        // Now we will setup our model
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
        
        // And bind issues to table view
        // Here is where the magic happens, with only one binding
        // we have filled up about 3 table view data source methods
        // let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: IndexPath(row: row, section: 0))
        issueTrackerModel
            .trackIssues()
            .bind(to: tableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = item.title
                
                print(item.title)
                
                return cell
            }.disposed(by: disposeBag)
        
        
        // Here we tell table view that if user clicks on a cell,
        // and the keyboard is still visible, hide it
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
            }).disposed(by: disposeBag)
    }
}
