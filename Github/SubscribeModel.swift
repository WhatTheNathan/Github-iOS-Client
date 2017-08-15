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
    var repoUrl: String
    var imageUrl: URL
    var description: String
    var eventID: String
    var userNameRange: NSRange
    var repoNameRange: NSRange
    
    init(_ userName:String,
         _ action: String,
         _ created: Date,
         _ repoName: String,
         _ repoUrl: String,
         _ imageUrl:URL,
         _ description:String,
         _ eventID: String,
         _ userNameRange: NSRange,
         _ repoNameRange: NSRange) {
        self.userName = userName
        self.action = action
        self.created = created
        self.repoName = repoName
        self.repoUrl = repoUrl
        self.imageUrl = imageUrl
        self.description = description
        self.eventID = eventID
        self.userNameRange = userNameRange
        self.repoNameRange = repoNameRange
    }
}
