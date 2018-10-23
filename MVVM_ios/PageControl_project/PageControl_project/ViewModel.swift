//
//  ViewModel.swift
//  PageControl_project
//
//  Created by Victor Amelin on 7/25/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ViewModel {
    
    private let dataSource = [
        UIImage(named: "img_01"),
        UIImage(named: "img_02"),
        UIImage(named: "img_03"),
        UIImage(named: "img_04")
    ]
    
    func getData() -> Observable<[UIImage?]> {
        let obsDataSource = Observable.just(dataSource)
        
        return obsDataSource
    }
}
