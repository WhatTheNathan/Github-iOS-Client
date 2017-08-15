//
//  TitleModule.swift
//  Github
//
//  Created by Nathan on 12/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON

class TitleModule{
    var userName : String
    var userID : String
    var imageUrl: String
    var homeUrl: String
    var followers : String
    var followersUrl : String
    var repos : String
    var reposUrl : String
    var followings : String
    var followingsUrl : String
    
    
    init(_ userName : String,
         _ userID : String,
         _ imageUrl : String,
         _ homeUrl : String,
         _ followers : String,
         _ followersUrl : String,
         _ repos : String,
         _ reposUrl : String,
         _ followings : String,
         _ followingsUrl : String) {
        self.userName = userName
        self.userID = userID
        self.imageUrl = imageUrl
        self.homeUrl = homeUrl
        self.followers = followers
        self.followersUrl = followersUrl
        self.repos = repos
        self.reposUrl = reposUrl
        self.followings = followings
        self.followingsUrl = followingsUrl
    }
    
    convenience init(_ json : JSON){
        self.init(json["userName"].stringValue,
                  json["userID"].stringValue,
                  json["imageUrl"].stringValue,
                  json["homeUrl"].stringValue,
                  json["followers"].stringValue,
                  json["followersUrl"].stringValue,
                  json["repos"].stringValue,
                  json["reposUrl"].stringValue,
                  json["followings"].stringValue,
                  json["followingsUrl"].stringValue)
    }
    
    func toJSON() -> JSON {
        return JSON([
            "userName" : userName,
            "imageUrl" : imageUrl
            ])
    }
}
