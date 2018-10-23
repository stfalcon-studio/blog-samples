//
//  Model.swift
//  ReactX
//
//  Created by Victor Amelin on 7/6/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let id: Int
    let name: String
    let language: String
    let fullName: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case language
        case name
        case fullName = "full_name"
    }
}

struct Issue: Decodable {
    let id: Int
    let number: Int
    let title: String
    let body: String
}
