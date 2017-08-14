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
    var followers : String
    var repos : String
    var followings : String
    
    init(_ userName : String,
         _ userID : String,
         _ imageUrl : String,
         _ followers : String,
         _ repos : String,
         _ followings : String) {
        self.userName = userName
        self.userID = userID
        self.imageUrl = imageUrl
        self.followers = followers
        self.repos = repos
        self.followings = followings
    }
    
    convenience init(_ json : JSON){
        self.init(json["userName"].stringValue,
                  json["userID"].stringValue,
                  json["imageUrl"].stringValue,
                  json["followers"].stringValue,
                  json["repos"].stringValue,
                  json["followings"].stringValue)
    }
    
    func toJSON() -> JSON {
        return JSON([
            "userName" : userName,
            "imageUrl" : imageUrl
            ])
    }
}
