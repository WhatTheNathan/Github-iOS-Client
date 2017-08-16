//
//  ReposModel.swift
//  Github
//
//  Created by Nathan on 14/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftDate

class ReposModel{
    var repoName : String
    var repoFullName : String
    var repoID : String
    var repoType : String
    var description : String
    var updateTime : DateInRegion
    var language : String
    
    init(_ repoName: String,
         _ repoFullName : String,
         _ repoID: String,
         _ repoType: String,
         _ description: String,
         _ updateTime: DateInRegion,
         _ language: String){
        self.repoName = repoName
        self.repoFullName = repoFullName
        self.repoID = repoID
        self.repoType = repoType
        self.description = description
        self.updateTime = updateTime
        self.language = language
    }
}
