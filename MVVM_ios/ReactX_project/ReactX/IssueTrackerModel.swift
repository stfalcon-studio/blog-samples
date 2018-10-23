//
//  IssueTrackerModel.swift
//  ReactX
//
//  Created by Victor Amelin on 7/6/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import Moya
import RxSwift
import RxOptional

struct IssueTrackerModel {
    
    let provider: MoyaProvider<GitHub>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository?> in
                return self.findRepository(name: name)
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository else { return Observable.just(nil) }
                
                return self.findIssues(repository: repository)
            }
            .replaceNilWith([])
    }
    
    private func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return provider.rx
            .request(GitHub.issues(repositoryFullName: repository.fullName))
            .map { data -> [Issue] in
                let response = try data.map(Issue.self)
                return [response]
            }
            .asObservable()
            .catchErrorJustReturn([])
            .debug()
    }
    
    private func findRepository(name: String) -> Observable<Repository?> {
        return provider.rx
            .request(GitHub.repo(fullName: name))
            .map { data -> Repository in
                let response = try data.map(Repository.self)
                return response
            }
            .asObservable()
            .catchErrorJustReturn(nil)
            .debug()
    }
}
