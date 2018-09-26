//
//  GithubModel.swift
//  SigTuple
//
//  Created by Coffeebeans on 26/09/18.
//  Copyright © 2018 Coffeebeans. All rights reserved.
//

import Foundation

//
//  GitHubModel.swift
//  SigTuple
//
//  Created by Coffeebeans on 25/09/18.
//  Copyright © 2018 Coffeebeans. All rights reserved.
//

import Foundation

struct Issues:Codable {
    let issues:[GitHubModel]?
}

struct GitHubModel:Codable {
    
    let url:String?
    let number:Int?
    let title:String?
    let user:User?
    let pull_request:PullRequest?
}

struct PullRequest:Codable {
    let url:String?
    let html_url:String?
    let diff_url:String?
    let patch_url:String?
}

struct User:Codable {
    let login:String?
    let id:Int?
    let node_id:String?
    let avatar_url:String?
}
