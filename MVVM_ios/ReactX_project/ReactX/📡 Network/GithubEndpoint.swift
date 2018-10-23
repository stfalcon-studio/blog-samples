//
//  GithubEndpoint.swift
//  ReactX
//
//  Created by Victor Amelin on 7/5/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import Moya

enum GitHub {
    case userProfile(username: String)
    case repos(username: String)
    case repo(fullName: String)
    case issues(repositoryFullName: String)
}

extension GitHub: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .userProfile(let name): return  "/users/\(name.URLEscapedString)/repos"
        case .repos(let name): return "/users/\(name.URLEscapedString)/repos"
        case .repo(let name): return "/repos/\(name.URLEscapedString)"
        case .issues(let repositoryName): return "/repost\(repositoryName)/issues"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .repos: return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: .utf8)!
            
        case .userProfile(let name): return "{\"login\": \"\(name)\", \"id\": 100}".data(using: .utf8)!
            
        case .repo: return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: .utf8)!
            
        case .issues: return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}
