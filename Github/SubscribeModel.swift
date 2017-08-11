//
//  SubscribeModel.swift
//  Github
//
//  Created by Nathan on 09/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

class SubscribeModel{
    var userName: String
    var action: String
    var created: Date
    var repoName: String
    var imageUrl : URL
    var description: String
    var eventID : String
    
    init(_ userName:String,
         _ action: String,
         _ created: Date,
         _ repoName: String,
         _ imageUrl:URL,
         _ description:String,
         _ eventID: String) {
        self.userName = userName
        self.action = action
        self.created = created
        self.repoName = repoName
        self.imageUrl = imageUrl
        self.description = description
        self.eventID = eventID
    }
}
