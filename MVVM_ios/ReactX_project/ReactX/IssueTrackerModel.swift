//
//  IssueTrackerModel.swift
//  ReactX
//
//  Created by Victor Amelin on 7/6/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {
    let provider: RxMoyaProvider<GitHub>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository?> in
                
                return self.findRepository(name)
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository else { return Observable.just(nil) }
                
                return self.findIssues(repository)
            }
            .replaceNilWith([])
    }
    
    private func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return self.provider
        .request(GitHub.Issues(repositoryFullName: repository.fullName))
        .debug()
        .mapArrayOptional(Issue.self)
    }
    
    private func findRepository(name: String) -> Observable<Repository?> {
        return self.provider
        .request(GitHub.Repo(fullName: name))
        .debug()
        .mapObjectOptional(Repository.self)
    }
}