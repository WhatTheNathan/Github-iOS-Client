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
    var created: String
    var repoName: String
    var imageUrl : String
    var text: String
    
    init(_ userName:String, _ action: String, _ created: String, _ repoName: String, _ imageUrl:String, _ text:String) {
        self.userName = userName
        self.action = action
        self.created = created
        self.repoName = repoName
        self.imageUrl = imageUrl
        self.text = text
    }
}
